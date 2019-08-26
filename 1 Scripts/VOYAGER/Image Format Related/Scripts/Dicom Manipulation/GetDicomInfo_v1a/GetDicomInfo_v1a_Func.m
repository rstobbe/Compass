%====================================================
%
%====================================================

function [INFO,err] = GetDicomInfo_v1a_Func(INPUT,INFO)

Status('busy','Info');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
clear INPUT;

%---------------------------------------------
% Find contents of folder
%---------------------------------------------
info = dicominfo(INFO.file)
PatientName = info.PatientName

Status2('done','',2);

