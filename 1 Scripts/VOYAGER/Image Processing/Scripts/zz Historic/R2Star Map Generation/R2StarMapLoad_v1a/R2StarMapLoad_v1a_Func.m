%===========================================
% 
%===========================================

function [MAPGEN,err] = R2StarMapLoad_v1a_Func(MAPGEN,INPUT)

Status2('busy','Calculate R2StarMap',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
IM0 = INPUT.IM0;
CALT = INPUT.CALT;
clear INPUT;

%---------------------------------------------
% Runc R2Start map
%---------------------------------------------
func = str2func([MAPGEN.calcfunc,'_Func']);  
INPUT.IM0 = IM0;
INPUT.visuals = MAPGEN.visuals;
[CALT,err] = func(CALT,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
MAPGEN.IMG = CALT.IMG;


Status2('done','',2);
Status2('done','',3);

