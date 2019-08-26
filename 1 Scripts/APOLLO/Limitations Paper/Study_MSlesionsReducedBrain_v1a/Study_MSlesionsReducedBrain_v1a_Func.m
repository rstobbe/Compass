%======================================================
% 
%======================================================

function [SBLD,err] = Study_MSlesionsReducedBrain_v1a_Func(SBLD,INPUT)

Status('busy','MS Lesions Study (Reduced VOI - Brain Model)');
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
Mean_0p05 = GetData(DataNames,CellData,'Mean_0p05');
Mean_0p1 = GetData(DataNames,CellData,'Mean_0p10');
Mean_0p125 = GetData(DataNames,CellData,'Mean_0p125');
Mean_0p15 = GetData(DataNames,CellData,'Mean_0p15');
Mean_0p175 = GetData(DataNames,CellData,'Mean_0p175');
Mean_0p2 = GetData(DataNames,CellData,'Mean_0p20');
Mean_0p225 = GetData(DataNames,CellData,'Mean_0p225');
Mean_0p25 = GetData(DataNames,CellData,'Mean_0p25');
Mean_0p3 = GetData(DataNames,CellData,'Mean_0p30');
Mean_C = GetData(DataNames,CellData,'Mean_C');
Vol = GetData(DataNames,CellData,'Vol');
Rel_Full = Mean_Full./Mean_C;
Rel_0p05 = Mean_0p05./Mean_C;
Rel_0p1 = Mean_0p1./Mean_C;
Rel_0p125 = Mean_0p125./Mean_C;
Rel_0p15 = Mean_0p15./Mean_C;
Rel_0p175 = Mean_0p175./Mean_C;
Rel_0p2 = Mean_0p2./Mean_C;
Rel_0p225 = Mean_0p225./Mean_C;
Rel_0p25 = Mean_0p25./Mean_C;
Rel_0p3 = Mean_0p3./Mean_C;

%---------------------------------------------
% Get SRF (Smearing Remnant Fraction)
%---------------------------------------------
bSRF_Full = GetData(DataNames,CellData,'bSRF_Full');
bSRF_0p05 = GetData(DataNames,CellData,'bSRF_0p05');
bSRF_0p1 = GetData(DataNames,CellData,'bSRF_0p10');
bSRF_0p125 = GetData(DataNames,CellData,'bSRF_0p125');
bSRF_0p15 = GetData(DataNames,CellData,'bSRF_0p15');
bSRF_0p175 = GetData(DataNames,CellData,'bSRF_0p175');
bSRF_0p2 = GetData(DataNames,CellData,'bSRF_0p20');
bSRF_0p225 = GetData(DataNames,CellData,'bSRF_0p225');
bSRF_0p25 = GetData(DataNames,CellData,'bSRF_0p25');
bSRF_0p3 = GetData(DataNames,CellData,'bSRF_0p30');

%---------------------------------------------
% Plot
%---------------------------------------------
figure(100); hold on;
for n = 1:length(Vol)
    plot([bSRF_Full(n) bSRF_0p05(n) bSRF_0p1(n) bSRF_0p125(n) bSRF_0p15(n) bSRF_0p175(n) bSRF_0p2(n) bSRF_0p225(n) bSRF_0p25(n) bSRF_0p3(n)],[Rel_Full(n) Rel_0p05(n) Rel_0p1(n) Rel_0p125(n) Rel_0p15(n) Rel_0p175(n) Rel_0p2(n) Rel_0p225(n) Rel_0p25(n) Rel_0p3(n)]-1,'r-');
end
plot(bSRF_Full,Rel_Full-1,'ro');
box on;
ylim([-0.1 0.6]);
xlim([0 0.35]);

bSRF = [bSRF_Full;bSRF_0p05;bSRF_0p1;bSRF_0p125;bSRF_0p15;bSRF_0p175;bSRF_0p2;bSRF_0p225;bSRF_0p25;bSRF_0p3];
Rel = [Rel_Full;Rel_0p05;Rel_0p1;Rel_0p125;Rel_0p15;Rel_0p175;Rel_0p2;Rel_0p225;Rel_0p25;Rel_0p3];
good = not(isnan(bSRF));
bSRF = bSRF(good);
Rel = Rel(good);
tbl = table(bSRF,Rel,'VariableNames',{'bSRF','Rel'});
bmdl = fitlm(tbl)

good = not(isnan(Rel_Full));
RelInc_Full = Rel_Full(good)-1;
bSRF_Full = bSRF_Full(good);
bSRF_Full0 = [ones(length(bSRF_Full),1) bSRF_Full];
b = RelInc_Full.'/bSRF_Full0.'
test = [0.02 1];
plot(test,b(2)*test + b(1),'r-');



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

