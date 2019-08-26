%=========================================================
% 
%=========================================================

function [STDYANLZ,err] = Study_Analysis_v1a_Func(STDYANLZ,INPUT)

Status('busy','Study Analysis');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
STUDY = INPUT.STUDY;
ANLZ = INPUT.ANLZ;
clear INPUT

%---------------------------------------------
% ROI Analysis
%---------------------------------------------
func = str2func([STDYANLZ.analysisfunc,'_Func']);  
INPUT.STUDY = STUDY;
[ANLZ,err] = func(ANLZ,INPUT);
if err.flag
    return
end

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);
