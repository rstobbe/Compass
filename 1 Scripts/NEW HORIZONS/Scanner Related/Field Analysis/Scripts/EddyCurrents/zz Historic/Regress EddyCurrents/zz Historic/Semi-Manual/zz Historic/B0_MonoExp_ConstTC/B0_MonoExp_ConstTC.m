%==================================
% Monoexponential
%==================================

function [B0beta,B0fit,SCRPTipt] = B0_MonoExp_ConstTC(gofftime,B0eddy1,SCRPTipt)

timeconst = str2double(SCRPTipt(strcmp('B0_TC (ms)',{SCRPTipt.labelstr})).entrystr)/1000;
regstart = str2double(SCRPTipt(strcmp('B0_regstart (s)',{SCRPTipt.labelstr})).entrystr);
regstop = str2double(SCRPTipt(strcmp('B0_regstop (s)',{SCRPTipt.labelstr})).entrystr);

ind1 = find(gofftime>=regstart,1,'first');
ind2 = find(gofftime>=regstop,1,'first');
if isempty(ind2)
    ind2 = length(gofftime);
end
gofftimeSub = gofftime(ind1:ind2);
B0eddy1Sub = B0eddy1(ind1:ind2);

func = @(P,t) P(1)*exp(-t/timeconst); 
Est = [B0eddy1Sub(1)];
options = statset('Robust','off','WgtFun','');
[B0beta,resid,jacob,sigma,mse] = nlinfit(gofftimeSub,B0eddy1Sub,func,Est,options);
B0beta
ci = nlparci(B0beta,resid,'covar',sigma)

B0fit.subtime = gofftimeSub;
B0fit.subvals = B0beta(1)*(exp(-(gofftimeSub)/timeconst));
B0fit.fulltime = [0 gofftime];
B0fit.fullvals = B0beta(1)*(exp(-(B0fit.fulltime)/timeconst));

[SCRPTipt] = AddToPanelOutput(SCRPTipt,'B0_FitMag',B0beta(1),'mT');