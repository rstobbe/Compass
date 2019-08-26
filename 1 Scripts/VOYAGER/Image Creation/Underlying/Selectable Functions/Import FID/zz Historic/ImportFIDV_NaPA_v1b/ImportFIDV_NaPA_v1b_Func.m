%=========================================================
%
%=========================================================

function [FID,err] = ImportFIDV_NaPA_v1b_Func(FID,INPUT)

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
[Text,abortflag,abort] = Load_ParamsV_v1a([FID.path,'\params']);
if abortflag == 1
    err.flag = 1;
    err.msg = abort;
    return
end
[ExpPars,err] = CreateParamStructV_NaPA_v1a(Text);
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
[FIDmat] = ImportExpArrayFIDmatV_v1a([FID.path,'\fid']);

%--------------------------------------------
% Return
%--------------------------------------------
FID.FIDmat = FIDmat;

Status2('done','',2);
Status2('done','',3);


