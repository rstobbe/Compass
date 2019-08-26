%======================================================
% 
%======================================================

function [SBLD,err] = Study_MSlesionsReducedSal_v1a_Func(SBLD,INPUT)

Status('busy','MS Lesions Study (Reduced VOI - Saline Model)');
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
Mean_0p1 = GetData(DataNames,CellData,'Mean_0p1');
Mean_0p2 = GetData(DataNames,CellData,'Mean_0p2');
Mean_0p3 = GetData(DataNames,CellData,'Mean_0p3');
Mean_0p4 = GetData(DataNames,CellData,'Mean_0p4');
Mean_0p5 = GetData(DataNames,CellData,'Mean_0p5');
Mean_0p6 = GetData(DataNames,CellData,'Mean_0p6');
Mean_0p7 = GetData(DataNames,CellData,'Mean_0p7');
Mean_0p8 = GetData(DataNames,CellData,'Mean_0p8');
Mean_0p9 = GetData(DataNames,CellData,'Mean_0p9');
Mean_C = GetData(DataNames,CellData,'Mean_C');
Vol = GetData(DataNames,CellData,'Vol');
Rel_Full = Mean_Full./Mean_C;
Rel_0p1 = Mean_0p1./Mean_C;
Rel_0p2 = Mean_0p2./Mean_C;
Rel_0p3 = Mean_0p3./Mean_C;
Rel_0p4 = Mean_0p4./Mean_C;
Rel_0p5 = Mean_0p5./Mean_C;
Rel_0p6 = Mean_0p6./Mean_C;
Rel_0p7 = Mean_0p7./Mean_C;
Rel_0p8 = Mean_0p8./Mean_C;
Rel_0p9 = Mean_0p9./Mean_C;

%---------------------------------------------
% Get SRF (Smearing Remnant Fraction)
%---------------------------------------------
sSRF_Full = GetData(DataNames,CellData,'sSRF_Full160');
sSRF_0p1 = GetData(DataNames,CellData,'sSRF_0p1');
sSRF_0p2 = GetData(DataNames,CellData,'sSRF_0p2');
sSRF_0p3 = GetData(DataNames,CellData,'sSRF_0p3');
sSRF_0p4 = GetData(DataNames,CellData,'sSRF_0p4');
sSRF_0p5 = GetData(DataNames,CellData,'sSRF_0p5');
sSRF_0p6 = GetData(DataNames,CellData,'sSRF_0p6');
sSRF_0p7 = GetData(DataNames,CellData,'sSRF_0p7');
sSRF_0p8 = GetData(DataNames,CellData,'sSRF_0p8');
sSRF_0p9 = GetData(DataNames,CellData,'sSRF_0p9');

%---------------------------------------------
% Plot
%---------------------------------------------
figure(100); hold on;
for n = 1:length(Vol)
    plot([sSRF_Full(n) sSRF_0p1(n) sSRF_0p2(n) sSRF_0p3(n) sSRF_0p4(n) sSRF_0p5(n) sSRF_0p6(n) sSRF_0p7(n) sSRF_0p8(n) sSRF_0p9(n)],[Rel_Full(n) Rel_0p1(n) Rel_0p2(n) Rel_0p3(n) Rel_0p4(n) Rel_0p5(n) Rel_0p6(n) Rel_0p7(n) Rel_0p8(n) Rel_0p9(n)]-1,'b-');
end
plot(sSRF_Full,Rel_Full-1,'bo');
box on;
ylim([-0.1 0.6]);

sSRF = [sSRF_Full;sSRF_0p1;sSRF_0p2;sSRF_0p3;sSRF_0p4;sSRF_0p5;sSRF_0p6;sSRF_0p7;sSRF_0p8;sSRF_0p9];
Rel = [Rel_Full;Rel_0p1;Rel_0p2;Rel_0p3;Rel_0p4;Rel_0p5;Rel_0p6;Rel_0p7;Rel_0p8;Rel_0p9]-1;
good = not(isnan(sSRF));
sSRF = sSRF(good);
Rel = Rel(good);
tbl = table(sSRF,Rel,'VariableNames',{'sSRF','Rel'});
bmdl = fitlm(tbl)

good = not(isnan(Rel_Full));
RelInc_Full = Rel_Full(good)-1;
sSRF_Full = sSRF_Full(good);
sSRF_Full0 = [ones(length(sSRF_Full),1) sSRF_Full];
%sSRF_Full0 = [sSRF_Full];
s = RelInc_Full.'/sSRF_Full0.'
test = [0.1 1];
plot(test,s(2)*test + s(1),'b-');
%plot(test,s(1)*test,'b-');

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

