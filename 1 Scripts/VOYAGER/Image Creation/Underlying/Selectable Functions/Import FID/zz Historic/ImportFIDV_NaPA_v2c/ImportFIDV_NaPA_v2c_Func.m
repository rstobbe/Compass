%=========================================================
%
%=========================================================

function [FID,err] = ImportFIDV_NaPA_v2c_Func(FID,INPUT)

Status2('busy','Load FID',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMP = INPUT.IC.IMP;
KDCCOR = FID.KDCCOR;
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
% Get Parameters
%---------------------------------------------
[Text,err] = Load_ParamsV_v1a([FID.path,'\params']);
if err.flag == 1
    return
end
[ExpPars,err] = CreateParamStructV_NaPA_v1a(Text);
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

%---------------------------------------------
% Load FID
%---------------------------------------------
split = IMP.SYS.split;
projmult = IMP.SYS.projmult;
npro = IMP.PROJimp.npro;
nproj = IMP.PROJimp.nproj;
nblocks = (nproj/split)/projmult;

if split == 1
    [FIDmat] = ImportExpArrayFIDmatV_v1a([FID.path,'\fid']);
else
    FIDmat0 = zeros(projmult,npro,nblocks,split);
    for n = 1:split
       temp = strtok(FID.path,'.');
       ptemp = [temp(1:length(temp)-2),num2str(str2double(temp(length(temp)-1:length(temp)))+(n-1),'%02d'),'.fid\fid'];
       [FIDmat0(:,:,:,n),~] = ImportSplitArrayFIDmatV_v1a(ptemp);
    end
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
func = str2func([FID.kdccorfunc,'_Func']);  
INPUT.FIDmat = FIDmat;
INPUT.nrcvrs = nrcvrs;
[KDCCOR,err] = func(KDCCOR,INPUT);
if err.flag
    return
end
clear INPUT;
FIDmat = KDCCOR.FIDmat;
KDCCOR = rmfield(KDCCOR,'FIDmat');

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
% Panel
%--------------------------------------------
Panel(1,:) = {'FID',FID.DatName,'Output'};
Panel(2,:) = {'',Text,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%--------------------------------------------
% Return
%--------------------------------------------
FID.Dat = FIDmat;
FID.ExpPars = ExpPars;
FID.KDCCOR = KDCCOR;
FID.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);


