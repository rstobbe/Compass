%=====================================================
%
%=====================================================

function [PSTP,err] = PostProc_None_v1a_Func(PSTP,INPUT)

Status2('busy','Post Processing',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PSTP.Im = INPUT.Im;

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'','','Output'};
PSTP.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

Status2('done','',2);
Status2('done','',3);



