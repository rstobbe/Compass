%===========================================
% 
%===========================================

function [DUM,err] = Dummy_v1a_Func(DUM,INPUT)

Status2('busy','Dummy Function',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

DUM.IMG = INPUT.IMG;
Panel(1,:) = {'','','Output'};
DUM.PanelOutput = cell2struct(Panel,{'label','value','type'},2);
