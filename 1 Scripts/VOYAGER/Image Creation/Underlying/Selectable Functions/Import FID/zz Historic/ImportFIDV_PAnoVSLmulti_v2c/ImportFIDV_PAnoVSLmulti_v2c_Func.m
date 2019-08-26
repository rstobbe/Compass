%=========================================================
%
%=========================================================

function [FID,err] = ImportFIDV_PAnoVSLmulti_v2c_Func(FID,INPUT)

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
ImpPars.gcoil = IMP.GWFM.GCOMP.gcoil;
ImpPars.fov = IMP.impPROJdgn.fov;
ImpPars.vox = IMP.impPROJdgn.vox;
%ImpPars.elip = IMP.impPROJdgn.elip;
ImpPars.nproj = IMP.PROJimp.nproj;
ImpPars.npro = IMP.PROJimp.npro;
ImpPars.tro = IMP.PROJimp.tro;
ImpPars.sampstart = round(IMP.PROJimp.sampstart*1000*1e9)/1e9;
ImpPars.dwell = round(IMP.PROJimp.dwell*1000*1e9)/1e9;
ImpPars.fb = IMP.TSMP.filtBW;
% - add test for xgshift...

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
AcqPars.fov = ExpPars.Acq.fov;
AcqPars.vox = ExpPars.Acq.vox;
%AcqPars.elip = ExpPars.Acq.elip;
AcqPars.nproj = ExpPars.Acq.nproj;
AcqPars.npro = ExpPars.Acq.npro;
AcqPars.tro = ExpPars.Acq.tro;
AcqPars.sampstart = ExpPars.Acq.sampstart;
AcqPars.dwell = round(ExpPars.Acq.dwell*1e9)/1e9;
AcqPars.fb = ExpPars.Acq.fb;
% - add test for xgshift...

%-------------------------------------------
% Read Additional Parameters
%-------------------------------------------
[ProcPar,err] = Load_ProcparV_v1a([FID.path,'procpar']);
if err.flag 
    return
end
params = {'arraydim'};
out = Parse_ProcparV_v1a(ProcPar,params);
ExpPars2 = cell2struct(out.',params.',1);
arraydim = ExpPars2.arraydim;

%---------------------------------------------
% Compare
%---------------------------------------------
[~,~,comperr] = comp_struct(ImpPars,AcqPars,'ImpPars','AcqPars');
if not(isempty(comperr))  
    set(findobj('tag','TestBox'),'string',Text);
    err.flag = 1;
    err.msg = 'Data Does Not Match ''Imp_File''';
    return
end

%---------------------------------------------
% Load FID
%---------------------------------------------
split = IMP.SYS.split;
projmult = IMP.SYS.projmult;
dummys = ExpPars.Sequence.dummys;
npro = IMP.PROJimp.npro;
nproj = IMP.PROJimp.nproj;
if (nproj/split)/projmult ~= 1;
    error();
end

FIDmat0 = zeros(projmult+dummys,npro,arraydim,split);

%temp = strtok(FID.path,'.');
%slshs = strfind(temp,'\');
%lastslsh = slshs(length(slshs));
%for n = 1:split 
%   ptemp = [temp(1:lastslsh),num2str(str2double(temp(lastslsh+1:length(temp)))+(n-1),'%02d'),'.fid\fid'];
%   [FIDmat0(:,:,:,n),FIDparams] = ImportSplitArrayFIDmatV_v1a(ptemp);
%end

temp = strtok(FID.path,'.');
for n = 1:split 
    ptemp = [temp(1:end-2),num2str(str2double(temp(end-1:end))+(n-1),'%02d'),'.fid'];
    if n > 1
        [~,err] = Load_ParamsV_v1a([ptemp,'\params']);
        if err.flag ~= 1
            err.flag = 1;
            err.msg = 'Split loading overrun (possible this scan aborted?)';
            return
        end
        err.flag = 0;
        err.msg = '';
    end
    [FIDmat0(:,:,:,n),FIDparams] = ImportSplitArrayFIDmatV_v1a([ptemp,'\fid']);
end

%---------------------------------------------
% Steady-State Test
%---------------------------------------------
if strcmp(FID.visuals,'Yes');
    FIDmat = [];
    for s = 1:split
        FIDmat = cat(1,FIDmat,squeeze(FIDmat0(:,:,:,s)));
    end
    figure(901); hold on;
    plot(angle(FIDmat(:,1,1)));
    title('First Data Point Phase');
    xlabel('Trajectory Number');     
    figure(902); hold on;
    plot(abs(FIDmat(:,1,1)));
    ylim([0 1.1*max(abs(FIDmat(:,1,1)))]);
    title('First Data Point Magnitude');
    xlabel('Trajectory Number');    
end
    
%---------------------------------------------
% Drop Dummies
%---------------------------------------------
FIDmat0 = FIDmat0(dummys+1:projmult+dummys,:,:,:);

%---------------------------------------------
% Consolidate
%---------------------------------------------
FIDmat = [];
for s = 1:split
    FIDmat = cat(1,FIDmat,squeeze(FIDmat0(:,:,:,s)));
end

%---------------------------------------------
% Update in Future...
%---------------------------------------------
nrcvrs = 1;

%---------------------------------------------
% Plot  (update for nrcvrs > 1)
%---------------------------------------------
if strcmp(FID.visuals,'Yes');
    tFIDmat = FIDmat(:,:,1);
    figure(1001); hold on; 
    plot(mean(real(tFIDmat),1),'r'); plot(mean(imag(tFIDmat),1),'b');
    plot([1 AcqPars.npro],[0 0],'k:'); xlim([1 AcqPars.npro]);
    xlabel('Readout Points'); title('DC Offset (Mean of All Trajectories)');
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
    tFIDmat = FIDmat(:,:,1);
    figure(1001);
    plot(mean(real(tFIDmat),1),'r','linewidth',2); plot(mean(imag(tFIDmat),1),'b','linewidth',2);

    figure(1002); hold on;
    plot(abs(tFIDmat(:,1)));
    title('First Data Point Magnitude Test');
    xlabel('Trajectory Number');    
    
    figure(1003); hold on;
    plot(angle(tFIDmat(:,1)));
    title('First Data Point Phase Test');
    xlabel('Trajectory Number');      
end

%--------------------------------------------
% Image Params for Recon
%--------------------------------------------
ReconPars.fovx = AcqPars.fov;
ReconPars.fovy = AcqPars.fov;
ReconPars.fovz = AcqPars.fov;
ReconPars.voxx = AcqPars.vox;
ReconPars.voxy = AcqPars.vox;
ReconPars.voxz = AcqPars.vox;

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
FID.DCCOR = DCCOR;


Status2('done','',2);
Status2('done','',3);


