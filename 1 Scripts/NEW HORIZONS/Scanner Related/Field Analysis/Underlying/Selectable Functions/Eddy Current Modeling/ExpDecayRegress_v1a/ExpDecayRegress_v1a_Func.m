%==================================
% 
%==================================

function [ECM,err] = ExpDecayRegress_v1a_Func(ECM,INPUT)

Status('busy','Regress Eddy Currents');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Gmeas = INPUT.Gmeas;
Time = INPUT.Time;
Gmax = INPUT.Gmax;
fullTime = INPUT.fullTime;
clear INPUT;

%-----------------------------------------------------
% Common
%-----------------------------------------------------
tcest = ECM.tcest;
magest = ECM.magest;

%-----------------------------------------------------
% Regression Functions
%-----------------------------------------------------
if length(tcest) == 1
    func = @(P,t) P(1)*exp(-t/P(2)); 
    Est = [magest(1) tcest(1)];
elseif length(tcest) == 2
    func = @(P,t) P(1)*exp(-t/P(2)) + P(3)*exp(-t/P(4));
    Est = [magest(1) tcest(1) magest(2) tcest(2)];
end
    
%-----------------------------------------------------
% Regression
%-----------------------------------------------------
options = statset('Robust','off','WgtFun','');
[beta,resid,jacob,sigma,mse] = nlinfit(Time,Gmeas,func,Est,options);
beta
ci = nlparci(beta,resid,'covar',sigma)
ECM.beta = beta;
ECM.ci = ci;

%-----------------------------------------------------
% Panel
%-----------------------------------------------------
if length(tcest) == 1
    ECM.tc(1) = beta(2);
    ECM.mag(1) = 100*beta(1)/Gmax;
    Panel(1,:) = {'Tc (ms)',ECM.tc,'Output'};
    Panel(2,:) = {'Mag (%)',ECM.mag,'Output'};    
elseif length(tcest) == 2
    ECM.tc(1) = beta(2);
    ECM.mag(1) = 100*beta(1)/Gmax;
    ECM.tc(2) = beta(4);
    ECM.mag(2) = 100*beta(3)/Gmax;
    Panel(1,:) = {'Tc1 (ms)',ECM.tc1,'Output'};
    Panel(2,:) = {'Mag1 (%)',ECM.mag1,'Output'};    
    Panel(3,:) = {'Tc2 (ms)',ECM.tc2,'Output'};
    Panel(4,:) = {'Mag2 (%)',ECM.mag2,'Output'};    
elseif length(tcest) == 3

end

%-----------------------------------------------------
% Return Regression
%-----------------------------------------------------
ECM.Grgrs = func(beta,fullTime);

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
ECM.PanelOutput = PanelOutput;



