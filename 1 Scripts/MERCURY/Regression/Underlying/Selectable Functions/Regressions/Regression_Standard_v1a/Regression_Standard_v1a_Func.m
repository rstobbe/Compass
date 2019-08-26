%======================================================
% 
%======================================================

function [REG,err] = Regression_Standard_v1a_Func(REG,INPUT)

Status2('busy','Standard Regression',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
BLDEXP = INPUT.BLDEXP;
EXP = BLDEXP.EXP;
MODTST = REG.MODTST;
Data = INPUT.Data;
clear INPUT

%---------------------------------------------
% Setup Model for Testing
%---------------------------------------------
func = str2func([MODTST.method,'_Func']);  
INPUT.EXP = EXP;
INPUT.Op = 'Setup';
[MODTST,err] = func(MODTST,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Initial Estimates
%---------------------------------------------
REG.NumExps = BLDEXP.NumExps;
REG.Scans = BLDEXP.Scans;
iEstB1 = ones(1,REG.NumExps);
iEstScale = 2*(max(Data(:))/100)*ones(1,REG.NumExps);
REG.iEst = [MODTST.iEst iEstB1 iEstScale];

%---------------------------------------------
% Scale
%---------------------------------------------
REG.Scale = 1./REG.iEst;
lb = zeros(size(REG.iEst));
ub = 5*ones(size(REG.iEst));

%---------------------------------------------
% Simulate Experiment
%---------------------------------------------
P0 = ones(size(REG.iEst));
func = str2func([REG.method,'_Reg']);
regfunc = @(P0)func(P0,EXP,MODTST,REG,Data);

%---------------------------------------------
% Test
%---------------------------------------------
% tic
% Out = regfunc(P0);
% toc
% error

%---------------------------------------------
% For Rsquare Calc
%---------------------------------------------
DataArr = [];
for n = 1:REG.NumExps
    DataArr = [DataArr Data(n,1:REG.Scans(n))];
end

%---------------------------------------------
% Regression Setup
%---------------------------------------------
options = optimset( 'Algorithm','trust-region-reflective',...
                    'Display','iter','Diagnostics','on',...
                    'FinDiffType','forward',...                      
                    'DiffMinChange',0.0001,...
                    'TolFun',0.001,...
                    'TolX',0.001,...
                    'MaxIter',20);

[P,ResNorm,Residual,exitflag,output,lambda,jacobian] = lsqnonlin(regfunc,P0,lb,ub,options);
ci = nlparci(P,Residual,jacobian);

%---------------------------------------------
% Rsquare Calc
%---------------------------------------------
TotSumSqr = sum((DataArr-mean(DataArr)).^2);
Rsqr = 1 - ResNorm/TotSumSqr;

%---------------------------------------------
% Return
%---------------------------------------------
P = P./REG.Scale;
ci(:,1) = ci(:,1)./REG.Scale.';
ci(:,2) = ci(:,2)./REG.Scale.';

REG.P = P;
REG.ci = ci;
REG.Residual = Residual;
REG.ResNorm = ResNorm;
REG.Rsqr = Rsqr;

RegressionOut = P

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'Regression',REG.method,'Output'};
Panel(3,:) = {'Output',num2str(P,'%8.4f'),'Output'};
Panel(4,:) = {'CI(1)',num2str(ci(:,1).','%8.4f'),'Output'};
Panel(5,:) = {'CI(2)',num2str(ci(:,2).','%8.4f'),'Output'};
Panel(6,:) = {'ResNorm',ResNorm,'Output'};
Panel(7,:) = {'Rsqr',Rsqr,'Output'};
REG.Panel = [MODTST.Panel;Panel];
REG.PanelOutput = cell2struct(REG.Panel,{'label','value','type'},2);

Status2('done','',2);
Status2('done','',3);




