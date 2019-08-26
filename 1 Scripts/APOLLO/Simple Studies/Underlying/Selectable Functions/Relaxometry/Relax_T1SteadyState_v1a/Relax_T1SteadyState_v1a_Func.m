%======================================================
% 
%======================================================

function [ANLZ,err] = Relax_T1SteadyState_v1a_Func(ANLZ,INPUT)

Status2('busy','T1 Regression (Steady State)',2);
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
if not(strcmp(VarNames{1},'TR')) || not(strcmp(VarNames{2},'Flip')) 
    err.flag = 1;
    err.msg = 'Excel Probably not T1_SteadyState';
    return
end
cellData = table2cell(tabledata);
cTR = cellData(:,1);
cFlip = cellData(:,2);
cVals = cellData(:,3);
for n = 1:length(cFlip)
    TR(n) = cTR{n};
    Flip(n) = cFlip{n};
    Vals(n) = cVals{n};
end

%---------------------------------------------
% Do Relaxometry
%---------------------------------------------
INPUT.TR = TR;
INPUT.Flip = pi*Flip/180;
INPUT.Vals = Vals;
regfunc = @(P)Reg_T1SteadyState(P,INPUT); 

P0 = [1000 1000];
%[P,ResNorm,Residual,exitflag,output,lambda,jacobian] = lsqnonlin(regfunc,P0,lb,ub,options);
[P,ResNorm,Residual,exitflag,output,lambda,jacobian] = lsqnonlin(regfunc,P0);
ci = nlparci(P,Residual,jacobian);

figure(20)
plot(Vals,'k*');
hold on

%P = [10000,800];
SimVals = Sim_T1SteadyState(P,INPUT); 
plot(SimVals,'r*');

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'Method',ANLZ.method,'Output'};
Panel(3,:) = {'Data',Data.file,'Output'};
Panel(4,:) = {'T1 (ms)',P(2),'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
ANLZ.PanelOutput = PanelOutput;
ANLZ.Panel = Panel;
ANLZ.Name = 'T1SteadyState';

Status2('done','',2);
Status2('done','',3);

%=======================================================
% Reg_T1SteadyState
%=======================================================
function F = Reg_T1SteadyState(P,INPUT) 

Vals = INPUT.Vals;
Sim = Sim_T1SteadyState(P,INPUT);
F = Vals - Sim;

%=======================================================
% Sim_T1SteadyState
%=======================================================
function Sim = Sim_T1SteadyState(P,INPUT) 

TR = INPUT.TR;
Flip = INPUT.Flip;
Sim = P(1) * (1 - exp(-TR/P(2))).*sin(Flip) ./ (1 - exp(-TR/P(2)).*cos(Flip));
