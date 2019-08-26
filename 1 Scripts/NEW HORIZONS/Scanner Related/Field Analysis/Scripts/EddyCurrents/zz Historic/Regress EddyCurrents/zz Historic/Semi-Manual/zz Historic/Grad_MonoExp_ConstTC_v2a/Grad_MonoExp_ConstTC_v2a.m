%==================================
% Monoexponential
%==================================

function [Gbeta,Gfit,SCRPTipt] = Grad_MonoExp_ConstTC_v2a(time,Geddy,SCRPTipt,Params)

regstart = str2double(SCRPTipt(strcmp('Grad_regstart (ms)',{SCRPTipt.labelstr})).entrystr);
regstop = str2double(SCRPTipt(strcmp('Grad_regstop (ms)',{SCRPTipt.labelstr})).entrystr);
starttime = str2double(SCRPTipt(strcmp('Grad_start (ms)',{SCRPTipt.labelstr})).entrystr);
timeconst = str2double(SCRPTipt(strcmp('Grad_TC (ms)',{SCRPTipt.labelstr})).entrystr);

ind1 = find(time>=regstart,1,'first');
ind2 = find(time<=regstop,1,'last');
if isempty(ind2)
    ind2 = length(time);
end
timeSub = time(ind1:ind2);
if starttime ~= 0
    timeSub = timeSub - timeSub(1) + starttime;
end
GeddySub = Geddy(ind1:ind2);

func = @(P,t) P(1)*exp(-t/timeconst); 
Est = GeddySub(1);
options = statset('Robust','off','WgtFun','');
[Gbeta,resid,jacob,sigma,mse] = nlinfit(timeSub,GeddySub,func,Est,options);
Gbeta
ci = nlparci(Gbeta,resid,'covar',sigma)

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
Gfit.interptime = (0:step:timeSub(length(timeSub)))+regstart;
Gfit.interpvals = Gbeta(1)*(exp(-(Gfit.interptime)/timeconst));

