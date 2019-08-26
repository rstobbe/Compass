%==================================
% Monoexponential
%==================================

function [Gbeta,Gfit,SCRPTipt] = Grad_MonoExp_v2a(time,Geddy,SCRPTipt,Params)

regstart = str2double(SCRPTipt(strcmp('Grad_regstart (ms)',{SCRPTipt.labelstr})).entrystr);
regstop = str2double(SCRPTipt(strcmp('Grad_regstop (ms)',{SCRPTipt.labelstr})).entrystr);
starttime = str2double(SCRPTipt(strcmp('Grad_start (ms)',{SCRPTipt.labelstr})).entrystr);
est = str2double(SCRPTipt(strcmp('Grad_est (ms)',{SCRPTipt.labelstr})).entrystr);

ind1 = find(time>=regstart,1,'first');
ind2 = find(time<=regstop,1,'last');
if isempty(ind2)
    ind2 = length(time);
end
if starttime == regstart
    starttime = time(ind1);
end
regstart = time(ind1);
timeSub = time(ind1:ind2);
timeSub = timeSub - timeSub(1) + starttime;
GeddySub = Geddy(ind1:ind2);

func = @(P,t) P(1)*exp(-t/P(2)); 
Est = [GeddySub(1) est];
options = statset('Robust','off','WgtFun','');
[Gbeta,resid,jacob,sigma,mse] = nlinfit(timeSub,GeddySub,func,Est,options);
Gbeta
ci = nlparci(Gbeta,resid,'covar',sigma)

[SCRPTipt] = AddToPanelOutput(SCRPTipt,'G_tc (ms)','0output',Gbeta(2),'0numout');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'G_mag (uT/m)','0output',Gbeta(1),'0numout');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'G_mag (%)','0output',0.1*Gbeta(1)/Params.gval,'0numout');

step = 0.01;
if timeSub(length(timeSub)) > 10000
    step = 10;
elseif timeSub(length(timeSub)) > 1000
    step = 1;
elseif timeSub(length(timeSub)) > 100
    step = 0.1;
end
Gfit.interptime = (timeSub(1):step:timeSub(length(timeSub)));
Gfit.interpvals = Gbeta(1)*(exp(-(Gfit.interptime)/Gbeta(2)));
if regstart ~= starttime
    Gfit.interptime = Gfit.interptime + regstart;
end


