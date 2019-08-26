%======================================================
% 
%======================================================

function [ANLZ,err] = Relax_T2Mono_v1a_Func(ANLZ,INPUT)

Status2('busy','T2 Regression',2);
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
VarNames = tabledata.Properties.VariableNames;
% if not(strcmp(VarNames{1},'T2'))
%     err.flag = 1;
%     err.msg = 'Excel Probably not T2';
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
Est = [Vals(1) 1];
options = statset('Robust','off','WgtFun','');
[beta,resid,jacob,sigma,mse] = nlinfit(Del,Vals,@Reg_monoT1,Est,options);
beta
ci = nlparci(beta,resid,'covar',sigma)

figure(20)
plot(Del,Vals,'k*');
hold on
t = (0:0.1:60);
plot(t,beta(1)*exp(-t/beta(2)));

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'Method',ANLZ.method,'Output'};
Panel(3,:) = {'Data',Data.file,'Output'};
Panel(4,:) = {'T2 (ms)',beta(2),'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
ANLZ.PanelOutput = PanelOutput;
ANLZ.Panel = Panel;
ANLZ.Name = 'T2mono';

Status2('done','',2);
Status2('done','',3);


%=======================================================
% Mono T1
%=======================================================
function F = Reg_monoT1(P,t) 
F = P(1) * exp(-t/P(2));




