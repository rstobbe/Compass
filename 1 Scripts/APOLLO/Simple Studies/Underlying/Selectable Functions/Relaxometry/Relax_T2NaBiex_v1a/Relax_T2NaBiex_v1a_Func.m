%======================================================
% 
%======================================================

function [ANLZ,err] = Relax_T2NaBiex_v1a_Func(ANLZ,INPUT)

Status2('busy','T2star Regression',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Data = INPUT.Data;
clear INPUT

%---------------------------------------------
% Read Excel
%---------------------------------------------
tabledata = readtable([Data.path,Data.file]);
% VarNames = tabledata.Properties.VariableNames;
% if not(strcmp(VarNames{1},'TE'))
%     err.flag = 1;
%     err.msg = 'Excel Probably not TE';
%     return
% end
cellData = table2cell(tabledata);
cDel = cellData(:,1);
cVals = cellData(:,2);
for n = 1:length(cDel)
    Del(n) = cDel{n};
    Vals(n) = cVals{n};
end

%---------------------------------------------
% Do Relaxometry
%---------------------------------------------
Est = [Vals(1) 1 20];
options = statset('Robust','off','WgtFun','');
[beta,resid,jacob,sigma,mse] = nlinfit(Del,Vals,@RegFunc,Est,options);
ci0 = nlparci(beta,resid,'covar',sigma);
ci = squeeze(ci0(:,2)) - beta.';

%---------------------------------------------
% Rsquare Calc
%---------------------------------------------
ResSumSqr = sum(resid.^2);
TotSumSqr = sum((Vals-mean(Vals)).^2);
Rsqr = 1 - ResSumSqr/TotSumSqr;

%---------------------------------------------
% Plot
%---------------------------------------------
figure(20)
plot(Del,Vals,'k*');
hold on
t = (0:0.1:60);
plot(t,beta(1)*(0.6*exp(-t/beta(2))+0.4*exp(-t/beta(3))));

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'Method',ANLZ.method,'Output'};
Panel(3,:) = {'T2fast (ms)',[num2str(beta(2),'%2.3g'),' +/- ',num2str(ci(2),'%2.2g')],'Output'};
Panel(4,:) = {'T2slow (ms)',[num2str(beta(3),'%2.3g'),' +/- ',num2str(ci(3),'%2.2g')],'Output'};
Panel(5,:) = {'Rsqr',Rsqr,'Output'};
ANLZ.Panel = Panel;
ANLZ.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

ANLZ.Name = 'T2NaBiex';

Status2('done','',2);
Status2('done','',3);


%=======================================================
% RegFunc
%=======================================================
function F = RegFunc(P,t) 
F = P(1)*(0.6*exp(-t/P(2))+0.4*exp(-t/P(3)));




