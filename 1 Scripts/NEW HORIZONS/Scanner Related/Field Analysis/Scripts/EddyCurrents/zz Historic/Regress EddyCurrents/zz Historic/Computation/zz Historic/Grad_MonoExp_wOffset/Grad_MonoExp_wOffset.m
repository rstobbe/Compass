%==================================
% Monoexponential
%==================================

function [Gbeta,Gfit,SCRPTipt] = Grad_MonoExp_wOffset(gofftime,Geddy,SCRPTipt,Clr,figno)

regstart = str2double(SCRPTipt(strcmp('Grad_regstart (s)',{SCRPTipt.labelstr})).entrystr);
regstop = str2double(SCRPTipt(strcmp('Grad_regstop (s)',{SCRPTipt.labelstr})).entrystr);

ind1 = find(gofftime>=regstart,1,'first');
ind2 = find(gofftime>=regstop,1,'first');
if isempty(ind2)
    ind2 = length(gofftime);
end
gofftimeSub = gofftime(ind1:ind2);
GeddySub = Geddy(ind1:ind2);

func = @(P,t) P(1)*exp(-t/P(2))+P(3); 
Est = [GeddySub(1) 0.1 0];
options = statset('Robust','off','WgtFun','');
[Gbeta,resid,jacob,sigma,mse] = nlinfit(gofftimeSub,GeddySub,func,Est,options);
Gbeta
ci = nlparci(Gbeta,resid,'covar',sigma)

[SCRPTipt] = AddToPanelOutput(SCRPTipt,'G_tc (ms)',Gbeta(2)*1000,'');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'G_mag (mT/m)',Gbeta(1),'');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'G_offset (mT/m)',Gbeta(3),'');

Gfit.tottime = [0 gofftime];
Gfit.totvals = Gbeta(1)*(exp(-(Gfit.tottime)/Gbeta(2)))+Gbeta(3);
Gfit.fulltime = gofftime;
Gfit.fullvals = Gbeta(1)*(exp(-(Gfit.fulltime)/Gbeta(2)))+Gbeta(3);

figure(figno); hold on;
plot(Gfit.tottime,Gfit.totvals,[Clr,'-']);

figure(600); hold on;
plot([0 max(gofftime)],[0 0],'k:');
plot(Gfit.fulltime,Geddy-Gfit.fullvals,[Clr,'-']);


