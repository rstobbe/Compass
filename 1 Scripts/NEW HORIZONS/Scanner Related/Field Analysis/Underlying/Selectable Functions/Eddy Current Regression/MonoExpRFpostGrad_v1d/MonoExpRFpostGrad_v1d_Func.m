%==================================================
% 
%==================================================

function [MONO,err] = MonoExpRFpostGrad_v1d_Func(MONO,INPUT)

Status2('busy','Regress Long Eddy Currents',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
EDDY = INPUT.MFEVO;
clear INPUT;

%-----------------------------------------------------
% Test for B0 Viability
%-----------------------------------------------------
Params = EDDY.TF.Params;
if isfield(Params,'position')                                       % need to add to SMIS
    if strcmp(Params.graddir,Params.position)
        goodB0 = 1;
    else
        goodB0 = 0;
    end
    if strcmp(MONO.selfield,'B0Field') && goodB0 == 0
        err.flag = 1;
        err.msg = 'Experiment not compatible with B0 measurement';
        return
    end
end
    
%-----------------------------------------------------
% Get Values
%-----------------------------------------------------
B0cal = MONO.b0cal;
Gcal = MONO.gcal;
gval = EDDY.gval;
time = EDDY.Time;
eddy = EDDY.(MONO.selfield);

%-----------------------------------------------------
% Isolate Segment
%-----------------------------------------------------
ind1 = find(time>=MONO.datastart,1,'first');
ind2 = find(time<=MONO.datastop,1,'last');
if isempty(ind2)
    ind2 = length(time);
end
MONO.datastart = time(ind1);
MONO.datastop = time(ind2);
MONO.timeSub = time(ind1:ind2);
MONO.eddySub = eddy(ind1:ind2);

%-----------------------------------------------------
% Initial Plot
%-----------------------------------------------------
if time(end) > 5000
    tscale = 0.001;
    Timelab = '(s)';
else
    tscale = 1;
    Timelab = '(ms)';
end
if strcmp(MONO.selfield,'B0Field')
    YLab = 'B0 Evolution (uT)';
    scale = 1000;
else
    YLab = 'Gradient Evolution (uT/m)';
    scale = 1000;
end
figure(5000); hold on;
plot(time*tscale,eddy*scale,'k','linewidth',1);
plot(MONO.timeSub*tscale,MONO.eddySub*scale,'b*','linewidth',1);
plot([0 max(time*tscale)],[0 0],'k:'); 
ylim([min([eddy*scale 0]) max([eddy*scale 0])]); xlim([0 max(time*tscale)])
xlabel(['Time After Gradient (',Timelab,')']); ylabel(YLab);
title('Monoexponential Regression');

%-----------------------------------------------------
% Regression
%-----------------------------------------------------
options = statset('Robust','off','WgtFun','');
ind = find(not(isnan(MONO.eddySub)),1,'first');
magest = MONO.eddySub(ind);
if MONO.consttc == 0
    func = @(P,t) P(1)*exp(-t/P(2)); 
    Est = [magest MONO.tcest];
    [beta,resid,jacob,sigma,mse] = nlinfit(MONO.timeSub,MONO.eddySub,func,Est,options);
else
    func = @(P,t) P(1)*exp(-t/MONO.tcest); 
    Est = magest;
    [beta,resid,jacob,sigma,mse] = nlinfit(MONO.timeSub,MONO.eddySub,func,Est,options);
    beta(2) = MONO.tcest;
end  
beta
ci = nlparci(beta,resid,'covar',sigma)
MONO.beta = beta;
MONO.ci = ci;

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
step = 0.01;
if time(end) > 10000
    step = 10;
elseif time(end) > 1000
    step = 1;
elseif time(end) > 100
    step = 0.1;
end
MONO.interptime = (0:step:time(end));
MONO.interpvals = beta(1)*(exp(-(MONO.interptime)/beta(2)));

figure(5000); hold on;
plot(MONO.interptime*tscale,MONO.interpvals*scale,'r-','linewidth',2);

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'Tc (ms)',beta(2),'Output'};
if strcmp(MONO.selfield,'B0Field') 
    Panel(2,:) = {'Mag (uT)',beta(1)*scale,'Output'};
    MONO.CompuTpG = beta(1)*scale/gval;
    MONO.CompSysPcnt = beta(1)*scale/(B0cal*gval);
    Panel(3,:) = {'Comp (uTpG)',MONO.CompuTpG,'Output'};
    Panel(4,:) = {'CompSysPcnt (%)',MONO.CompSysPcnt,'Output'};
else
    Panel(2,:) = {'Mag (uT/m)',beta(1)*scale,'Output'};
    MONO.CompPcnt = -100*beta(1)/gval;
    MONO.CompSysPcnt = -100*Gcal*beta(1)/gval;
    Panel(3,:) = {'CompPcnt (%)',MONO.CompPcnt,'Output'};  
    Panel(4,:) = {'CompSysPcnt (%)',MONO.CompSysPcnt,'Output'};    
end
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
MONO.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);

