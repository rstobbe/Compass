%=========================================================
% 
%=========================================================

function [IMLD,err] = ImCurrentDispLoad_v1a_Func(IMLD,INPUT)

global IMAGEANLZ

Status2('done','Select Current Image',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
clear INPUT

%---------------------------------------------
% Get Image
%---------------------------------------------
IMLD.IMAGEANLZ = IMAGEANLZ.(IMLD.tab)(IMLD.axnum);
IMLD.totgblnums = IMLD.IMAGEANLZ.totgblnum;

err.flag = 0;
err.msg = '';
