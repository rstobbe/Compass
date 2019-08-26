%======================================================
% 
%======================================================

function [SBLD,err] = Study_MSlesionsFull_v1a_Func(SBLD,INPUT)

Status('busy','MS Lesions Study (Full VOI)');
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
% Get Excel
%---------------------------------------------
TableData = readtable([InputData.path,InputData.file]);
DataNames = TableData.Properties.VariableNames(2:end);
CellData = table2cell(TableData);

%---------------------------------------------
% Get Data
%---------------------------------------------
Mean_Full = GetData(DataNames,CellData,'Mean_Full');
Mean_C = GetData(DataNames,CellData,'Mean_C');
Vol = GetData(DataNames,CellData,'Vol');
Rel_Full = Mean_Full./Mean_C;
vals = sum(not(isnan(Rel_Full)))

%---------------------------------------------
% Get Noise Error
%---------------------------------------------
NEI95_Full = GetData(DataNames,CellData,'NEI95_Full');
NEI95_C = GetData(DataNames,CellData,'NEI95_C');
RelErr_Full = Rel_Full.*sqrt((NEI95_Full./Mean_Full).^2 + (NEI95_C./Mean_C).^2);
%RelErr_FullTest = NEI95_Full./Mean_C;             % assumes no error in comparable

%---------------------------------------------
% Get SRF (Smearing Remnant Fraction)
%---------------------------------------------
bSRF_Full = GetData(DataNames,CellData,'bSRF_Full');
sSRF_Full = GetData(DataNames,CellData,'sSRF_Full160');

%---------------------------------------------
% Plot
%---------------------------------------------
figure(100); hold on;
plot(Vol,Rel_Full-1,'ro');
box on;

figure(101); hold on;
plot(Vol,RelErr_Full,'ro');
ylim([0 0.15]);
box on;

figure(102); hold on;
%plot(Vol,1-bSRF_Full,'ro');
%plot(Vol,1-sSRF_Full,'bo');
plot(Vol,bSRF_Full,'ro');
plot(Vol,sSRF_Full,'bo');
ylim([0 0.6]);
box on;

Status2('done','',1);
end



%========================================================
% Get Data
%========================================================
function data = GetData(DataNames,CellData,title)
    ind0 = strfind(DataNames,title);
    for n = 1:length(ind0)
        test = ind0{n};
        if isempty(test)
            ind(n+1) = false;
        else
            ind(n+1) = true;
        end
    end
    data = cell2mat(CellData(:,ind));
end

