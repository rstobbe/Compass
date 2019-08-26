%======================================================
% 
%======================================================

function [SBLD,err] = Study_MSlesionsFullRegression_v1a_Func(SBLD,INPUT)

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
%sSRF_Full = GetData(DataNames,CellData,'sSRF_Full0');
%sSRF_Full = GetData(DataNames,CellData,'sSRF_Full200');
%sSRF_Full = GetData(DataNames,CellData,'sSRF_Full165');
sSRF_Full = GetData(DataNames,CellData,'sSRF_Full160');

%---------------------------------------------
% Remove Nan
%---------------------------------------------
good = not(isnan(Rel_Full));
RelInc_Full = Rel_Full(good)-1;
RelErr_Full = RelErr_Full(good);
bSRF_Full = bSRF_Full(good);
sSRF_Full = sSRF_Full(good);

%---------------------------------------------
% Linear Model
%---------------------------------------------
tbl = table(bSRF_Full,RelInc_Full,'VariableNames',{'bSRF_Full','RelInc_Full'});
bmdl = fitlm(tbl)
tbl = table(sSRF_Full,RelInc_Full,'VariableNames',{'sSRF_Full','RelInc_Full'});
smdl = fitlm(tbl)

%---------------------------------------------
% Plot
%---------------------------------------------
figure(100); hold on;
plot(bSRF_Full,RelInc_Full,'ro');
plot(sSRF_Full,RelInc_Full,'bo');
box on;

bSRF_Full0 = [ones(length(bSRF_Full),1) bSRF_Full];
b = RelInc_Full.'/bSRF_Full0.'
sSRF_Full0 = [ones(length(sSRF_Full),1) sSRF_Full];
s = RelInc_Full.'/sSRF_Full0.'

plot(bSRF_Full,b(2)*bSRF_Full + b(1),'g-');
plot(sSRF_Full,s(2)*sSRF_Full + s(1),'g-');


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

