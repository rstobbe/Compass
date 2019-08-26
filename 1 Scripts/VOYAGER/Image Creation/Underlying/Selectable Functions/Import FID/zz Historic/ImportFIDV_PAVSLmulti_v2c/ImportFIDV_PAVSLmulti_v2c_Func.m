%=========================================================
%
%=========================================================

function [FID,err] = ImportFIDV_PAVSLmulti_v2c_Func(FID,INPUT)

Status2('busy','Load FID',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMP = INPUT.IC.IMP;
DCCOR = FID.DCCOR;
clear INPUT;

%---------------------------------------------
% Build Structure to Test with AcqPars
%---------------------------------------------
ImpPars.gcoil = IMP.KSMP.gcoil;
ImpPars.graddel = IMP.KSMP.graddel*1000;
ImpPars.fov = IMP.impPROJdgn.fov;
ImpPars.vox = IMP.impPROJdgn.vox;
ImpPars.elip = IMP.impPROJdgn.elip;
ImpPars.nproj = IMP.PROJimp.nproj;
ImpPars.npro = IMP.PROJimp.npro;
ImpPars.tro = IMP.PROJimp.tro;
ImpPars.sampstart = round(IMP.PROJimp.sampstart*1000*1e9)/1e9;
ImpPars.dwell = round(IMP.PROJimp.dwell*1000*1e9)/1e9;
ImpPars.fb = IMP.TSMP.filtBW;

%---------------------------------------------
% Get Parameters / determine sequence
%---------------------------------------------
[Text,err] = Load_ParamsV_v1a([FID.path,'\params']);
if err.flag == 1
    return
end
[seq] = Parse_ParamsV_v1a(Text,'sequence');
inds = strfind(seq,'_');
seqtype = seq(inds(1)+1:inds(2)-1);

%---------------------------------------------
% Create Parameter Structure
%---------------------------------------------
func = str2func(['CreateParamStructV_',seqtype,'_v1a']);
[ExpPars,err] = func(Text);
if err.flag == 1;
    return
end

%---------------------------------------------
% Build Structure to Test with ImpPars
%---------------------------------------------
AcqPars.gcoil = ExpPars.Acq.gcoil;
AcqPars.graddel = ExpPars.Acq.graddel;
AcqPars.fov = ExpPars.Acq.fov;
AcqPars.vox = ExpPars.Acq.vox;
AcqPars.elip = ExpPars.Acq.elip;
AcqPars.nproj = ExpPars.Acq.nproj;
AcqPars.npro = ExpPars.Acq.npro;
AcqPars.tro = ExpPars.Acq.tro;
AcqPars.sampstart = ExpPars.Acq.sampstart;
AcqPars.dwell = round(ExpPars.Acq.dwell*1e9)/1e9;
AcqPars.fb = ExpPars.Acq.fb;

%---------------------------------------------
% Compare
%---------------------------------------------
[~,~,comperr] = comp_struct(ImpPars,AcqPars,'ImpPars','AcqPars');
if not(isempty(comperr))
    err.flag = 1;
    err.msg = 'Data Does Not Match ''Imp_File''';
    return
end

%-------------------------------------------
% Read Shim Values
%-------------------------------------------
[ProcPar,err] = Load_ProcparV_v1a([FID.path,'procpar']);
params = {'z1c','z2c','z3c','z4c','x1','y1',...
          'xz','yz','xy','x2y2','x3','y3','xz2','yz2','zxy','zx2y2',...
          'tof'};
out = Parse_ProcparV_v1a(ProcPar,params);
Shim = cell2struct(out.',params.',1);

%-------------------------------------------
% Read Array Dim
%-------------------------------------------
params = {'arraydim','array'};
out = Parse_ProcparV_v1b(ProcPar,params);
ArrayDim = out{1};
ArrayText = out{2}{1};
if ArrayDim > 1
    ind = strfind(ArrayText,',');
    ArrayVars{1} = ArrayText(1:ind(1)-1);
    m = 2;
    for p = 2:length(ind)
        ArrayVars{m} = ArrayText(ind(p-1)+1:ind(p)-1);
        m = m+1;
    end
    if isempty(p)
        p = 1;
    end
    ArrayVars{m} = ArrayText(ind(p)+1:end);
    ArrayVals = Parse_ProcparV_v1b(ProcPar,ArrayVars);
    if length(ArrayVars) > 2
        err.flag = 1;
        err.msg = 'ImportFIDfunc does not handle multidim arrays';
        return
    end
    if strcmp(ArrayVars{1},'exparr')    
        err.flag = 1;
        err.msg = 'exparr should be the 2nd arrayed variable';          % i.e. exparr should be arrayed first
        return
    end
    %for n = 1:length(ArrayVars)
    %    Array.(ArrayVars{n}) = ArrayVals{n};
    %end
    Array.(ArrayVars{1}) = ArrayVals{1};    
    seqarr = length(Array.(ArrayVars{1}));
    projmultarrlen = length(ArrayVals{2});
    ExpPars.Array = Array;
    ExpPars.ArrayNames = ArrayVars{1};
else
    seqarr = 1;
    projmultarrlen = ArrayDim;
end

%---------------------------------------------
% Load FID
%---------------------------------------------
if projmultarrlen*seqarr ~= ArrayDim
    error;
end
split = IMP.SYS.split;
projmult = IMP.SYS.projmult;
npro = IMP.PROJimp.npro;
nproj = IMP.PROJimp.nproj;
if projmultarrlen ~= (nproj/split)/projmult;
    error;
end
nblocks = ArrayDim;

FIDmat0 = zeros(projmult,npro,nblocks,split);
for n = 1:split
   temp = strtok(FID.path,'.');
   ptemp = [temp(1:length(temp)-2),num2str(str2double(temp(length(temp)-1:length(temp)))+(n-1),'%02d'),'.fid\fid'];
   [FIDmat0(:,:,:,n),FIDparams] = ImportSplitArrayFIDmatV_v1a(ptemp);
end
if FIDparams.np ~= npro || FIDparams.nblocks ~= nblocks || FIDparams.ntraces ~= projmult
    error;
end

%---------------------------------------------
% RF phase cycle accomodate
%---------------------------------------------
phasecycle = ExpPars.Sequence.phasecycle;
dummys = ExpPars.Sequence.dummys;
if isnan(phasecycle)
    phasecycle = 0;
end
if phasecycle ~= 0
    phasearr = exp(1i*(phasecycle/180)*pi*((1:projmult)+dummys-1));
    nproarr = (1:npro);
    [PhArr,~] = meshgrid(phasearr,nproarr);
    PhArr = permute(PhArr,[2 1]);
    for s = 1:split
        for b = 1:nblocks
            FIDmat0(:,:,b,s) = PhArr.*FIDmat0(:,:,b,s);
        end
    end
end

%---------------------------------------------
% Consolidate
%---------------------------------------------
if nblocks == 1
    error
end
FIDmat = zeros(nproj,npro,seqarr);
for s = 1:split
    for q = 1:seqarr
        for b = 1:projmultarrlen/2
            blockind = (q-1)*projmultarrlen+b;
            FIDmat((b-1)*projmult+1:b*projmult,:,q) = FIDmat0(:,:,blockind,s);
        end
    end
end
for s = 1:split
    for q = 1:seqarr
        for b = projmultarrlen/2+1:projmultarrlen
            blockind = (q-1)*projmultarrlen+b;
            FIDmat((b-1)*projmult+1:b*projmult,:,q) = FIDmat0(:,:,blockind,s);
        end
    end
end

%---------------------------------------------
% Update in Future...
%---------------------------------------------
nrcvrs = 1;

%---------------------------------------------
% Magnitude Test
%---------------------------------------------
if strcmp(FID.visuals,'Yes');
    figure(1001); hold on; 
    for n = 1:seqarr
        tFIDmat = FIDmat(:,:,n);
        plot(mean(real(tFIDmat),1),'r','linewidth',2); plot(mean(imag(tFIDmat),1),'b','linewidth',2);
        plot([1 AcqPars.npro],[0 0],'k:'); xlim([1 AcqPars.npro/5]);
        xlabel('Initial Readout Points'); title('Magnitude Test (mean readout value)');
    end
end

%--------------------------------------------
% DC correction
%--------------------------------------------
func = str2func([FID.dccorfunc,'_Func']);  
INPUT.FIDmat = FIDmat;
INPUT.nrcvrs = nrcvrs;
INPUT.visuals = FID.visuals;
[DCCOR,err] = func(DCCOR,INPUT);
if err.flag
    return
end
clear INPUT;
FIDmat = DCCOR.FIDmat;
DCCOR = rmfield(DCCOR,'FIDmat');

%---------------------------------------------
% Plot  (update for nrcvrs > 1)
%---------------------------------------------
if strcmp(FID.visuals,'Yes');
    clr = ['r','b','g','c','m'];
    for n = 1:seqarr
        
        figure(1002); hold on;
        plot(abs(FIDmat(:,1,n)),clr(n));
        title('First Data Point Magnitude Test');
        xlabel('Trajectory Number');    

        figure(1003); hold on;
        plot(angle(FIDmat(:,1,n)),clr(n));
        title('First Data Point Phase Test');
        xlabel('Trajectory Number'); 
    end
end

%--------------------------------------------
% Image Params for Recon
%--------------------------------------------
ReconPars.Imfovx = AcqPars.fov;
ReconPars.Imfovy = AcqPars.fov;
ReconPars.Imfovz = AcqPars.fov;
ReconPars.orp = ExpPars.Sequence.orp;

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'FID',FID.DatName,'Output'};
Panel(2,:) = {'',Text,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
FID.PanelOutput = PanelOutput;

%--------------------------------------------
% Return
%--------------------------------------------
FID.FIDmat = FIDmat;
FID.ExpPars = ExpPars;
FID.ReconPars = ReconPars;
FID.Shim = Shim;
FID.DCCOR = DCCOR;


Status2('done','',2);
Status2('done','',3);


