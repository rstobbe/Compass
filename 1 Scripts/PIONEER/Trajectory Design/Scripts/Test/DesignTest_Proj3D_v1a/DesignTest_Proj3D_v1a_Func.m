%=========================================================
% 
%=========================================================

function [TSTTOP,err] = DesignTest_Proj3D_v1a_Func(TSTTOP,INPUT)

Status('busy','Test Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
DES = INPUT.DES;
TST = INPUT.TST;
clear INPUT

%---------------------------------------------
% Plot
%---------------------------------------------
func = str2func([TST.method,'_Func']);  
INPUT.DES = DES;
[TST,err] = func(TST,INPUT);
if err.flag
    return
end
clear INPUT
if isfield(TST,'Figure')
    TSTTOP.Figure = TST.Figure;
end
TSTTOP.name = TST.Name;

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
% Panel(1,:) = {'','','Output'};
% Panel(2,:) = {'',TSTTOP.method,'Output'};
% 
% TSTTOP.Panel = [Panel;TST.Panel];
% TSTTOP.PanelOutput = cell2struct(TSTTOP.Panel,{'label','value','type'},2);
% TSTTOP.ExpDisp = PanelStruct2Text(TSTTOP.PanelOutput);

Status2('done','',2);
Status2('done','',3);

