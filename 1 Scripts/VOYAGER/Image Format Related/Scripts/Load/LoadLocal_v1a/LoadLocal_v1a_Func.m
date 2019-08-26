%====================================================
%  
%====================================================

function [LDTOP,err] = LoadLocal_v1a_Func(LDTOP,INPUT)

Status('busy','Load Image');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
LOAD = INPUT.LOAD;
clear INPUT;

%----------------------------------------------
% Load Image
%----------------------------------------------
func = str2func([LDTOP.loadfunc,'_Func']);  
INPUT = struct();
[LOAD,err] = func(LOAD,INPUT);
if err.flag
    return
end
clear INPUT;

%----------------------------------------------
% Panel
%----------------------------------------------
Panel(1,:) = {'','','Output'};
IMG.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

IMG.Im = LOAD.Im;
LDTOP.IMG = IMG;

Status('done','');
Status2('done','',2);
Status2('done','',3);

