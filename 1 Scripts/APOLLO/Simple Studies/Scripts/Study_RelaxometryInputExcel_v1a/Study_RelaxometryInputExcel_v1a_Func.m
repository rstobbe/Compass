%=========================================================
% 
%=========================================================

function [STUDY,err] = Study_RelaxometryInputExcel_v1a_Func(STUDY,INPUT)

Status('busy','Study Analysis');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
ANLZ = INPUT.ANLZ;
Data = INPUT.Data;
clear INPUT

%---------------------------------------------
% Regression Analysis
%---------------------------------------------
func = str2func([STUDY.analysisfunc,'_Func']);  
INPUT.Data = Data;
[ANLZ,err] = func(ANLZ,INPUT);
if err.flag
    return
end

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'Method',STUDY.method,'Output'};
Panel(3,:) = {'Data',Data.label,'Output'};
STUDY.Panel = [Panel;ANLZ.Panel];
STUDY.PanelOutput = cell2struct(STUDY.Panel,{'label','value','type'},2);

%----------------------------------------------------
% Return
%----------------------------------------------------
DataName = strtok(Data.file,'.');
DataName = strtok(DataName,'Data_');
STUDY.Name = [ANLZ.Name,'_',DataName];

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);
