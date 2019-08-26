%====================================================
%
%====================================================

function [ANON,err] = AnonDicomHeader_v1b_Func(INPUT,ANON)

Status2('busy','Anonomize',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
oldfile = INPUT.oldfile;
newfile = INPUT.newfile;
clear INPUT;

%---------------------------------------------
% Anonymize Header
%---------------------------------------------
info = dicominfo(oldfile);
image = dicomread(oldfile);
%-----------------------------------------
info.PatientName.FamilyName = ANON.val;
info.PatientName.GivenName = '';
info.PatientName.MiddleName = '';
info.PatientAddress = '';
info.PatientTelephoneNumber = '';
info.PatientID = '';
%-----------------------------------------
dicomwrite(image,newfile,info);

Status2('done','',3);

