%======================================================
% 
%======================================================

function [SBLD,err] = Study_TubeRoiDependance_v1a_Func(SBLD,INPUT)

Status('busy','Tube ROI Dependence Study');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
InputData = INPUT.Data;
InputSEF = INPUT.SEF;
InputNEI = INPUT.NEI;
clear INPUT

%---------------------------------------------
% Get Data
%---------------------------------------------
tabledata = readtable([InputData.path,InputData.file]);
ImageNames = tabledata.Properties.VariableNames(2:end);
cellData = table2cell(tabledata);
sz = size(cellData);
for n = 1:sz(1)
    DataRoiNames{n} = cellData{n,1};
    for m = 2:length(ImageNames)
        Data(n,m-1) = cellData{n,m};
    end
end
for n = 1:sz(1)
    DataNei(n) = std(Data(n,:))*1.96;
    DataMean(n) = mean(Data(n,:));
end

%---------------------------------------------
% Get SEF
%---------------------------------------------
tabledata = readtable([InputSEF.path,InputSEF.file]);
cellData = table2cell(tabledata);
sz = size(cellData);
for n = 1:sz(1)
    SEFRoiNames{n} = cellData{n,1};
    SEF(n) = cellData{n,2};
end

%---------------------------------------------
% Get NEI
%---------------------------------------------
tabledata = readtable([InputNEI.path,InputNEI.file]);
cellData = table2cell(tabledata);
sz = size(cellData);
for n = 1:sz(1)
    NEIRoiNames{n} = cellData{n,1};
    NEI(n) = cellData{n,2};
end

%---------------------------------------------
% Get SEF
%---------------------------------------------
V0 = 1;
INPUT.Data = DataMean;
INPUT.SEF = SEF;
func = @(V)SefFit_Reg(V,INPUT);
[V,resnorm,residual,exitflag,output,~,jacobian] = lsqnonlin(func,V0);
DataMean = DataMean*V;
DataNei = DataNei*V;
CalcNei = NEI*V;

%---------------------------------------------
% Plot
%---------------------------------------------
rad = 13.4:-1:1.4;
figure(100); hold on;
plot(rad,DataMean,'k*');
plot(rad,SEF,'r');
for n = 1:sz(1)
    plot([rad(n) rad(n)],[DataMean(n)-DataNei(n),DataMean(n)+DataNei(n)],'k');
    %plot([rad(n)+0.1 rad(n)+0.1],[DataMean(n)-CalcNei(n),DataMean(n)+CalcNei(n)],'r');    
end
ylim([0 1.1]); 

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);
