%====================================================
%
%====================================================

function [ANLZ,err] = FidAnlz_v1a_Func(ANLZ,INPUT)

Status('busy','Single Fid Analysis');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
FEVOL = INPUT.FEVOL;
FIDANLZ = INPUT.FIDANLZ;
clear INPUT

%-----------------------------------------------------
% Load Fid
%-----------------------------------------------------
func = str2func([ANLZ.fevolfunc,'_Func']);
INPUT = struct();
[FEVOL,err] = func(FEVOL,INPUT);
if err.flag
    return
end
clear INPUT

%-----------------------------------------------------
% Fid Anlaysis
%-----------------------------------------------------
func = str2func([ANLZ.psbgfunc,'_Func']);
INPUT.FEVOL = FEVOL;
[FIDANLZ,err] = func(FIDANLZ,INPUT);
if err.flag
    return
end
clear INPUT

%-----------------------------------------------------
% Display Experiment Parameters
%-----------------------------------------------------
ANLZ.ExpDisp = [char(10) FEVOL.ExpDisp char(10) FIDANLZ.ExpDisp];

%--------------------------------------------
% Output Structure
%--------------------------------------------
ANLZ.FEVOL = FEVOL;
ANLZ.FIDANLZ = FIDANLZ;

Status('done','');
Status2('done','',2);
Status2('done','',3);
