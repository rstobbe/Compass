%=========================================================
%
%=========================================================

function [FID,err] = ImportFIDV_PAVSL_v2c_Func(FID,INPUT)

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
[Text2,err] = Load_ProcparV_v1a([FID.path,'procpar']);
params = {'z1c','z2c','z3c','z4c','x1','y1',...
          'xz','yz','xy','x2y2','x3','y3','xz2','yz2','zxy','zx2y2',...
          'tof'};
out = Parse_ProcparV_v1a(Text2,params);
Shim = cell2struct(out.',params.',1);

%---------------------------------------------
% Load FID
%---------------------------------------------
split = IMP.SYS.split;
projmult = IMP.SYS.projmult;
npro = IMP.PROJimp.npro;
nproj = IMP.PROJimp.nproj;
nblocks = (nproj/split)/projmult;

FIDmat0 = zeros(projmult,npro,nblocks,split);
for n = 1:split
   temp = strtok(FID.path,'.');
   ptemp = [temp(1:length(temp)-2),num2str(str2double(temp(length(temp)-1:length(temp)))+(n-1),'%02d'),'.fid\fid'];
   [FIDmat0(:,:,:,n),~] = ImportSplitArrayFIDmatV_v1a(ptemp);
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
FIDmat = [];
if nblocks > 1
    for s = 1:split
        for b = 1:nblocks/2
            FIDmat = cat(1,FIDmat,squeeze(FIDmat0(:,:,b,s)));
        end
    end
    for s = 1:split
        for b = nblocks/2+1:nblocks
            FIDmat = cat(1,FIDmat,squeeze(FIDmat0(:,:,b,s)));
        end
    end
else
    for s = 1:split
        FIDmat = cat(1,FIDmat,squeeze(FIDmat0(:,:,1,s)));
    end
end

%---------------------------------------------
% Update in Future...
%---------------------------------------------
nrcvrs = 1;

%---------------------------------------------
% Plot  (update for nrcvrs > 1)
%---------------------------------------------
if strcmp(FID.visuals,'Yes');
    figure(1001); hold on; 
    plot(mean(real(FIDmat),1),'r'); plot(mean(imag(FIDmat),1),'b');
    plot([1 AcqPars.npro],[0 0],'k:'); xlim([1 AcqPars.npro]);
    xlabel('Readout Points'); title('DC Offset Test');
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
    figure(1001);
    plot(mean(real(FIDmat),1),'r','linewidth',2); plot(mean(imag(FIDmat),1),'b','linewidth',2);

    figure(1002); hold on;
    plot(abs(FIDmat(:,1)));
    title('First Data Point Magnitude Test');
    xlabel('Trajectory Number');    
    
    figure(1003); hold on;
    plot(angle(FIDmat(:,1)));
    title('First Data Point Phase Test');
    xlabel('Trajectory Number');      
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


