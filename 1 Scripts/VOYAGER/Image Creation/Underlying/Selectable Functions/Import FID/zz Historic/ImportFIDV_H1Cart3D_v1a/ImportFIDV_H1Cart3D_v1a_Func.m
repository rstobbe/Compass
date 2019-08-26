%=========================================================
%
%=========================================================

function [FID,err] = ImportFIDV_H1Cart3D_v1a_Func(FID,INPUT)

Status2('busy','Load FID',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
clear INPUT;

%---------------------------------------------
% Get Parameters
%---------------------------------------------
[Text,abortflag,abort] = Load_ParamsV_v1a([FID.path,'\params']);
if abortflag == 1
    err.flag = 1;
    err.msg = abort;
    return
end
[ExpPars,err] = CreateParamStructV_H1Cart3D_v1a(Text);
if err.flag == 1;
    return
end

%---------------------------------------------
% Load FID
%---------------------------------------------
[FIDmat0] = ImportExpArrayFIDmatV_v1a([FID.path,'\fid']);

%---------------------------------------------
% Test Find Centre
%---------------------------------------------
FIDcentest = mean(abs(FIDmat0),1);
%figure(1); plot(FIDcentest);
centind = find(FIDcentest == max(FIDcentest),1);
test = max(FIDcentest)
test2 = max(abs(FIDmat0(:)))

%---------------------------------------------
% RF phase cycle accomodate
%---------------------------------------------
rfspoil = ExpPars.Sequence.rfspoil;
dummies = ExpPars.Sequence.dummies;
%[FIDmat] = RFspoil_uwnd_v1a(FIDmat0,dummies,rfspoil);
FIDmat = FIDmat0;

%---------------------------------------------
% Testing - only value if no phase encode
%---------------------------------------------
%phinit = unwrap(angle(FIDmat0(:,centind)));
%phinit = (angle(FIDmat0(:,centind)));
%figure(1); plot(phinit);
%phinit2 = [phinit(2:length(phinit));0];
%dif0 = phinit2 - phinit;
%phasecycle0 = 180*dif0/pi;
%test0 = mean(phasecycle0(1:length(phinit)-1));

%phinit = unwrap(angle(FIDmat(:,centind)));
%phinit2 = [phinit(2:length(phinit));0];
%dif1 = phinit2 - phinit;
%phasecycle1 = 180*dif1/pi;
%test1 = mean(phasecycle1(1:length(phinit)-1));

%--------------------------------------------
% Return
%--------------------------------------------
FID.FIDmat = FIDmat;
FID.ExpPars = ExpPars;

Status2('done','',2);
Status2('done','',3);


