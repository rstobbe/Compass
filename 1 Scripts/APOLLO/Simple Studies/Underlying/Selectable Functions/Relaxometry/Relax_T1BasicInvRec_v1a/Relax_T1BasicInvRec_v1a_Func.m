%======================================================
% 
%======================================================

function [ANLZ,err] = Relax_T1BasicInvRec_v1a_Func(ANLZ,INPUT)

Status2('busy','T1 Regression (Basic Inversion Recovery)',2);
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
if not(strcmp(VarNames{1},'TI'))
    err.flag = 1;
    err.msg = 'Excel Probably not T1';
    return
end
cellData = table2cell(tabledata);
cTI = cellData(:,1);
cVals = cellData(:,2);
for n = 1:length(cTI)
    TI(n) = cTI{n};
    Vals(n) = cVals{n};
end

%---------------------------------------------
% Do Relaxometry
%---------------------------------------------
Est = [Vals(end) -1 40];
options = statset('Robust','off','WgtFun','');
[beta,resid,jacob,sigma,mse] = nlinfit(TI,Vals,@Reg_monoT1,Est,options);
beta
ci = nlparci(beta,resid,'covar',sigma)

figure(20)
plot(TI,Vals,'k*');
hold on
t = (0:0.1:250);
plot(t,beta(1)*(1-(1-beta(2))*exp(-t/beta(3))));

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'Method',ANLZ.method,'Output'};
Panel(3,:) = {'Data',Data.file,'Output'};
Panel(4,:) = {'T1 (ms)',beta(3),'Output'};
Panel(5,:) = {'Inversion',beta(2),'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
ANLZ.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);


%=======================================================
% Mono T1
%=======================================================
function F = Reg_monoT1(P,t) 
F = P(1) * (1-(1-P(2))*exp(-t/P(3)));




