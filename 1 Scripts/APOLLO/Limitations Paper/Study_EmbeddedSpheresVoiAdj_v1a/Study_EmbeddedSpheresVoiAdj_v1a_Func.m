%======================================================
% 
%======================================================

function [SBLD,err] = Study_EmbeddedSpheresVoiAdj_v1a_Func(SBLD,INPUT)

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
sz = size(CellData);

Spheres = (2:sz(1)-1);
fracinc = cell2mat(CellData(Spheres,30));
sef = cell2mat(CellData(Spheres,31));
rNEImeas = cell2mat(CellData(Spheres,33));
rNEIcalc = cell2mat(CellData(Spheres,35));
rad = cell2mat(CellData(Spheres,2));

%---------------------------------------------
% Plot
%---------------------------------------------
figure(100); hold on;
plot(rad,fracinc,'r');
for n = 1:length(rad)
    h = plot([rad(n)-0.1 rad(n)-0.1],[fracinc(n)-rNEImeas(n) fracinc(n)+rNEImeas(n)],'r');
    %h.Color = [0.945 0.914 0.141];
end
plot(rad,sef,'b');
for n = 1:length(rad)
    h = plot([rad(n)+0.1 rad(n)+0.1],[sef(n)-rNEIcalc(n) sef(n)+rNEIcalc(n)],'b');
    %h.Color = [0.945 0.914 0.141];
end

ylim([-0.2 1.2]);

figure(101); hold on;
plot(rad,rNEImeas);
plot(rad,rNEIcalc);
ylim([0 0.15]);

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);
