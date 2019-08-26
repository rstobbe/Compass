%======================================================
% 
%======================================================

function [OUT,err] = Output_Dummy_v1a_Func(OUT,INPUT)

err.flag = 0;
err.msg = '';

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'Output',OUT.method,'Output'};
OUT.Panel = Panel;
OUT.PanelOutput = cell2struct(OUT.Panel,{'label','value','type'},2);

