%==================================
% Monoexponential
%==================================

function [Gbeta,Gfit,SCRPTipt] = Grad_MonoExp(time,Geddy,SCRPTipt,Params,Clr,figno)

regstart = str2double(SCRPTipt(strcmp('Grad_regstart (s)',{SCRPTipt.labelstr})).entrystr);
regstop = str2double(SCRPTipt(strcmp('Grad_regstop (s)',{SCRPTipt.labelstr})).entrystr);

ind1 = find(time>=regstart,1,'first');
ind2 = find(time<=regstop,1,'last');
if isempty(ind2)
    ind2 = length(time);
end
timeSub = time(ind1:ind2);
GeddySub = Geddy(ind1:ind2);

func = @(P,t) P(1)*exp(-t/P(2)); 
Est = [GeddySub(1) 5];
options = statset('Robust','off','WgtFun','');
[Gbeta,resid,jacob,sigma,mse] = nlinfit(timeSub,GeddySub,func,Est,options);
Gbeta
ci = nlparci(Gbeta,resid,'covar',sigma)

[SCRPTipt] = AddToPanelOutput(SCRPTipt,'G_tc (ms)',Gbeta(2)*1000,'0text','');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'G_mag (mT/m)',Gbeta(1),'0text','');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'G_mag (%)',100*Gbeta(1)/Params.gval,'0text','');

Gfit.tottime = [0 time];
Gfit.totvals = Gbeta(1)*(exp(-(Gfit.tottime)/Gbeta(2)));
Gfit.interptime = (0:0.01:Gfit.tottime(length(Gfit.tottime)));
Gfit.interpvals = Gbeta(1)*(exp(-(Gfit.interptime)/Gbeta(2)));

figure(figno); hold on;
plot(Gfit.interptime,Gfit.interpvals*1000,[Clr,'-']);

