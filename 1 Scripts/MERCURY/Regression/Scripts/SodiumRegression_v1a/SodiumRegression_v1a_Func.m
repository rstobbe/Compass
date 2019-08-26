%=========================================================
% 
%=========================================================

function [STUDY,err] = SodiumRegression_v1a_Func(STUDY,INPUT)

Status('busy','Sodium Regression');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
BLDEXP = INPUT.BLDEXP;
REG = INPUT.REG;
clear INPUT

%---------------------------------------------
% Build Experiment
%---------------------------------------------
func = str2func([BLDEXP.method,'_Func']);  
INPUT = [];
[BLDEXP,err] = func(BLDEXP,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Load DataFile
%---------------------------------------------
DataTable = readtable([STUDY.DataFile.path,STUDY.DataFile.file]);
DataCell = table2cell(DataTable);
Data = cell2mat(DataCell);

%---------------------------------------------
% Regression Analysis
%---------------------------------------------
func = str2func([REG.method,'_Func']);  
INPUT.BLDEXP = BLDEXP;
INPUT.Data = Data;
[REG,err] = func(REG,INPUT);
if err.flag
    return
end

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'Study',STUDY.method,'Output'};
Panel(3,:) = {'Data',STUDY.DataFile.label,'Output'};
STUDY.Panel = [Panel;BLDEXP.Panel;REG.Panel];
STUDY.PanelOutput = cell2struct(STUDY.Panel,{'label','value','type'},2);

STUDY.BLDEXP = BLDEXP;
STUDY.REG = REG;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);
