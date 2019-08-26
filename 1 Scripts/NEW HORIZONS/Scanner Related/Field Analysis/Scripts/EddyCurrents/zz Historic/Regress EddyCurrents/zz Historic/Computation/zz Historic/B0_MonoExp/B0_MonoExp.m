%==================================
% Monoexponential
%==================================

function [B0beta,B0fit,SCRPTipt] = B0_MonoExp(gofftime,B0eddy1,SCRPTipt,Params,Clr,figno)

regstart = str2double(SCRPTipt(strcmp('B0_regstart (s)',{SCRPTipt.labelstr})).entrystr);
regstop = str2double(SCRPTipt(strcmp('B0_regstop (s)',{SCRPTipt.labelstr})).entrystr);

ind1 = find(gofftime>=regstart,1,'first');
ind2 = find(gofftime<=regstop,1,'last');
if isempty(ind2)
    ind2 = length(gofftime);
end
gofftimeSub = gofftime(ind1:ind2);
B0eddy1Sub = B0eddy1(ind1:ind2);

func = @(P,t) P(1)*exp(-t/P(2)); 
Est = [B0eddy1Sub(1) 0.002];
options = statset('Robust','off','WgtFun','');
[B0beta,resid,jacob,sigma,mse] = nlinfit(gofftimeSub,B0eddy1Sub,func,Est,options);
B0beta
ci = nlparci(B0beta,resid,'covar',sigma)

[SCRPTipt] = AddToPanelOutput(SCRPTipt,'B0_tc (ms)',B0beta(2)*1000,'0text','');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'B0_mag (uT)',B0beta(1)*1000,'0text','');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'B0_mag (%)',B0beta(1)*1000/Params.B0cal,'0text','');

B0fit.tottime = [0 gofftime];
B0fit.totvals = B0beta(1)*(exp(-(B0fit.tottime)/B0beta(2)));
if gofftimeSub(length(gofftimeSub)) < 0.1
    B0fit.interptime = (0:0.001:B0fit.tottime(length(B0fit.tottime)));
else
    B0fit.interptime = (0:0.01:B0fit.tottime(length(B0fit.tottime)));
end
B0fit.interpvals = B0beta(1)*(exp(-(B0fit.interptime)/B0beta(2)));

figure(figno); hold on;
plot(B0fit.interptime,B0fit.interpvals*1000,[Clr,'-']);


