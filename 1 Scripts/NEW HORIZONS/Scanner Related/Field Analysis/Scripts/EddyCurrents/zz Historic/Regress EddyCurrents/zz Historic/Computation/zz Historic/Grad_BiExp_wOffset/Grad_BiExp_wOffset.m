%==================================
% Biexponential
%==================================

function [Gbeta,Gfit,SCRPTipt] = Grad_BiExp_wOffset(gofftime,Geddy1,SCRPTipt,Clr,figno)

regstart = str2double(SCRPTipt(strcmp('Grad_regstart (s)',{SCRPTipt.labelstr})).entrystr);
regstop = str2double(SCRPTipt(strcmp('Grad_regstop (s)',{SCRPTipt.labelstr})).entrystr);

ind1 = find(gofftime>=regstart,1,'first');
ind2 = find(gofftime>=regstop,1,'first');
if isempty(ind2)
    ind2 = length(gofftime);
end
gofftimeSub = gofftime(ind1:ind2);
Geddy1Sub = Geddy1(ind1:ind2);

func = @(P,t) P(1)*exp(-t/P(2)) + P(3)*exp(-t/P(4)) + P(5); 
Est = [Geddy1Sub(1)/2 0.3 Geddy1Sub(1)/2 0.1 0];
options = statset('Robust','off','WgtFun','');
[Gbeta,resid,jacob,sigma,mse] = nlinfit(gofftimeSub,Geddy1Sub,func,Est,options);
Gbeta
ci = nlparci(Gbeta,resid,'covar',sigma)

[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Grad_tc1 (ms)',Gbeta(2)*1000,'');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Grad_mag1 (mT/m)',Gbeta(1),'');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Grad_tc2 (ms)',Gbeta(4)*1000,'');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Grad_mag2 (mT/m)',Gbeta(3),'');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'Grad_offset (mT/m)',Gbeta(5),'');

Gfit.subtime = gofftimeSub;
Gfit.subvals = Gbeta(1)*(exp(-(gofftimeSub)/Gbeta(2))) + Gbeta(3)*(exp(-(gofftimeSub)/Gbeta(4))) + Gbeta(5);
Gfit.fulltime = gofftime;
Gfit.fullvals = Gbeta(1)*(exp(-(gofftime)/Gbeta(2))) + Gbeta(3)*(exp(-(gofftime)/Gbeta(4))) + Gbeta(5);

figure(figno); hold on;
%plot(Gfit.subtime,Gfit.subvals,'k*','linewidth',1);
plot(Gfit.fulltime,Gfit.fullvals,[Clr,'-']);

figure(600); hold on;
plot([0 max(gofftime)],[0 0],'k:');
plot(Gfit.fulltime,Geddy1-Gfit.fullvals,[Clr,'-']);
