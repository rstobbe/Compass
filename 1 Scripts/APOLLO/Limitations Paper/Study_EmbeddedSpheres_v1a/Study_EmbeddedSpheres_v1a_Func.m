%======================================================
% 
%======================================================

function [SBLD,err] = Study_EmbeddedSpheres_v1a_Func(SBLD,INPUT)

Status('busy','Embedded Sphere Study');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
InputData = INPUT.Data;
clear INPUT

%---------------------------------------------
% Get Data
%---------------------------------------------
TableData = readtable([InputData.path,InputData.file]);
DataNames = TableData.Properties.VariableNames(2:end);
CellData = table2cell(TableData);

Spheres = [2 5 8 11 14];
fracinc = cell2mat(CellData(Spheres,30));
sef = cell2mat(CellData(Spheres,31));
rNEImeas = cell2mat(CellData(Spheres,33));
rNEIcalc = cell2mat(CellData(Spheres,35));

%---------------------------------------------
% Plot
%---------------------------------------------
figure(100); hold on;
h = bar([fracinc sef]);
ylim([0 1]);

figure(101); hold on;
h = bar([rNEImeas rNEIcalc]);
ylim([0 0.1]);


Status2('done','',1);
Status2('done','',2);
Status2('done','',3);
