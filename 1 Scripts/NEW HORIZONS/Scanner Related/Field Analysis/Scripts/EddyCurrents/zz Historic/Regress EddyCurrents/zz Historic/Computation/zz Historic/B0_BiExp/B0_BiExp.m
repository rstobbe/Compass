%==================================
% Monoexponential
%==================================

function [B0beta,B0fit,SCRPTipt] = B0_BiExp(gofftime,B0eddy1,SCRPTipt,Clr,figno)

regstart = str2double(SCRPTipt(strcmp('B0_regstart (s)',{SCRPTipt.labelstr})).entrystr);
regstop = str2double(SCRPTipt(strcmp('B0_regstop (s)',{SCRPTipt.labelstr})).entrystr);

ind1 = find(gofftime>=regstart,1,'first');
ind2 = find(gofftime>=regstop,1,'first');
if isempty(ind2)
    ind2 = length(gofftime);
end
gofftimeSub = gofftime(ind1:ind2);
B0eddy1Sub = B0eddy1(ind1:ind2);

func = @(P,t) P(1)*exp(-t/P(2)) + P(3)*exp(-t/P(4)); 
Est = [B0eddy1Sub(1) 1 B0eddy1Sub(1) 0.1];
options = statset('Robust','off','WgtFun','');
[B0beta,resid,jacob,sigma,mse] = nlinfit(gofftimeSub,B0eddy1Sub,func,Est,options);
B0beta
ci = nlparci(B0beta,resid,'covar',sigma)

[SCRPTipt] = AddToPanelOutput(SCRPTipt,'B0_tc1 (ms)',B0beta(2)*1000,'');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'B0_mag1 (uT)',B0beta(1)*1000,'');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'B0_tc2 (ms)',B0beta(4)*1000,'');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'B0_mag2 (uT)',B0beta(3)*1000,'');

B0fit.tottime = [0 gofftime];
B0fit.totvals = B0beta(1)*(exp(-(B0fit.tottime)/B0beta(2))) + B0beta(3)*(exp(-(B0fit.tottime)/B0beta(4)));
B0fit.fulltime = gofftime;
B0fit.fullvals = B0beta(1)*(exp(-(B0fit.fulltime)/B0beta(2))) + B0beta(3)*(exp(-(B0fit.fulltime)/B0beta(4)));

figure(figno); hold on;
plot(B0fit.tottime,B0fit.totvals,[Clr,'-']);

figure(601); hold on;
plot([0 max(gofftime)],[0 0],'k:');
plot(B0fit.fulltime,B0eddy1-B0fit.fullvals,[Clr,'-']);
