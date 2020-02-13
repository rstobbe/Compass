%====================================================
%  
%====================================================

function [CTRST,err] = SetDefaultContrast_v1a_Func(CTRST,INPUT)

Status2('busy','Set Default Contrast',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG{1};
clear INPUT;

%---------------------------------------------
% New
%---------------------------------------------
DEFDISP.dispwid = [CTRST.min CTRST.max];
DEFDISP.colour = CTRST.colour;
DEFDISP.type = CTRST.type;
IMG.IMDISP.DEFDISP = DEFDISP;

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',CTRST.method,'Output'};
CTRST.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Return
%---------------------------------------------
CTRST.IMG = IMG;

Status2('done','',2);
Status2('done','',3);

