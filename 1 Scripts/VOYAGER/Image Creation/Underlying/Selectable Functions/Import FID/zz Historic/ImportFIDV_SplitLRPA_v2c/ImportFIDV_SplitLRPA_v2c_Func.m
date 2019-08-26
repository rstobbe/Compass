%=========================================================
%
%=========================================================

function [FID,err] = ImportFIDV_SplitLRPA_v2c_Func(FID,INPUT)

Status2('busy','Load FID',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMP = INPUT.IMP;
clear INPUT;

%---------------------------------------------
% Build Structure to Test with AcqPars
%---------------------------------------------
if isfield(IMP.KSMP,'gcoil')
    ImpPars.gcoil = IMP.KSMP.gcoil;
elseif isfield(IMP.GWFM.GCOMP,'gcoil')
    ImpPars.gcoil = IMP.GWFM.GCOMP.gcoil;
end
if isfield(IMP.KSMP,'graddel')
    ImpPars.graddel = IMP.KSMP.graddel*1000;
elseif isfield(IMP.GWFM.GCOMP,'graddel')
    ImpPars.graddel = IMP.GWFM.GCOMP.graddel;
end
%
% - add test for xgshift...
%
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
[Text,abortflag,abort] = Load_ParamsV_v1a([FID.path,'\params']);
if abortflag == 1
    err.flag = 1;
    err.msg = abort;
    return
end
[ExpPars,err] = CreateParamStructV_LRPA_v1a(Text);
if err.flag == 1;
    return
end
%Study = ExpPars.Study
%Setup = ExpPars.Setup
%Sequence = ExpPars.Sequence
%Acq = ExpPars.Acq

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

FIDmat0 = zeros(projmult,npro,nblocks,split);
for n = 1:split
   temp = strtok(FID.path,'.');
   ptemp = [temp(1:length(temp)-2),num2str(str2double(temp(length(temp)-1:length(temp)))+(n-1),'%02d'),'.fid\fid'];
   [FIDmat0(:,:,:,n),FIDparams] = ImportSplitArrayFIDmatV_v1a(ptemp);
end

%---------------------------------------------
% RF spoil accomodate
%---------------------------------------------
rfspoil = ExpPars.Sequence.rfspoil;
if strcmp(rfspoil,'y')

    %---------------------------------------------
    % RF spoil test
    %---------------------------------------------
    figure(1000); hold on;
    for s = 1:split
        SecPhase(s,:) = 180*(unwrap(angle(FIDmat0(:,1,1,s))))/pi;
        plot(SecPhase(s,:));
    end
    title('First Data Point Phase');
    ylabel('Phase (deg)'); 
    xlabel('Trajectory Number'); 
    spoilphase = (mean(SecPhase(:,projmult)) - mean(SecPhase(:,1)))/(projmult-1);
    plot((1:projmult),mean(SecPhase(:,1))+spoilphase*(0:projmult-1),'r');
    %rfspoilphase = ExpPars.Sequence.rfspoilphase;
    rfspoilphase = -spoilphase;
    
    %---------------------------------------------
    % RF spoil unwrap
    %---------------------------------------------    
    phasearr = exp(1i*(rfspoilphase/180)*pi*((1:projmult)));
    nproarr = (1:npro);
    [PhArr,~] = meshgrid(phasearr,nproarr);
    PhArr = permute(PhArr,[2 1]);
    for s = 1:split
        for b = 1:nblocks
            FIDmat0(:,:,b,s) = PhArr.*FIDmat0(:,:,b,s);
        end
    end

    %---------------------------------------------
    % RF spoil test
    %---------------------------------------------    
    figure(1000); hold on;
    for s = 1:split
        SecPhase(s,:) = 180*(unwrap(angle(FIDmat0(:,1,1,s))))/pi;
        plot(SecPhase(s,:),'g');
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

%--------------------------------------------
% Return
%--------------------------------------------
FID.ExpPars = ExpPars;
FID.FIDmat = FIDmat;
FID.FIDparams = FIDparams;

Status2('done','',2);
Status2('done','',3);


