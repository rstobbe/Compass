%======================================================
% 
%======================================================

function [OUT,err] = Output_RegressSignalDecay_v1a_Func(OUT,INPUT)

Status2('busy','Regress Signal Decay Over Acq',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
APP = INPUT.APP;
SIM = INPUT.SIM;
clear INPUT

%---------------------------------------------
% Get Acq Stard
%---------------------------------------------
AcqElm = APP.SIM.AcqElm;
ARR = APP.SIM.ARR;
AcqStart = ARR.SegBounds(AcqElm);
AcqStop = ARR.SegBounds(AcqElm+1);

%---------------------------------------------
% Data Across Acquisition
%---------------------------------------------
%Sample = AcqStart+0.05:1:AcqStop;
Sample = AcqStart:0.01:AcqStop;
Data = interp1(SIM.Time,SIM.Val,Sample);
%TE = Sample - ARR.SegBounds(2)/2;                       % assuming excitation in first slot
TE = Sample - Sample(1);

%Data = Data(:,3).';

%---------------------------------------------
% Plot
%---------------------------------------------
figure(1234512345); hold on;
plot(TE,Data); 
xlim([0 TE(end)]);
ylim([0 100]);

%---------------------------------------------
% Do Relaxometry
%---------------------------------------------
Est = [100 0.6 0.5 7.6];
options = statset('Robust','off','WgtFun','');
[beta,resid,jacob,sigma,mse] = nlinfit(TE,Data,@RegFunc,Est,options);
ci0 = nlparci(beta,resid,'covar',sigma);
ci = squeeze(ci0(:,2)) - beta.';
beta

CenComp = beta(1)*(1-beta(2))
OutComp = beta(1)*beta(2)

%CenComp = mean(Data(end-200:end-1))
%OutComp = Data(1)-CenComp

%---------------------------------------------
% Plot
%---------------------------------------------
figure(1234512345);
t = (0:0.1:TE(end));
plot(t,beta(1)*(beta(2)*exp(-t/beta(3))+(1-beta(2))*exp(-t/beta(4))));

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'Output',OUT.method,'Output'};
OUT.Panel = Panel;
OUT.PanelOutput = cell2struct(OUT.Panel,{'label','value','type'},2);

Status2('done','',2);
Status2('done','',3);

error

%=======================================================
% RegFunc
%=======================================================
function F = RegFunc(P,t) 
F = P(1)*(P(2)*exp(-t/P(3))+(1-P(2))*exp(-t/P(4)));



