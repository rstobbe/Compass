%==================================
% Monoexponential
%==================================

function [B0beta,B0fit,SCRPTipt] = B0_MonoExp_v2a(time,B0eddy,SCRPTipt,Params)

regstart = str2double(SCRPTipt(strcmp('B0_regstart (ms)',{SCRPTipt.labelstr})).entrystr);
regstop = str2double(SCRPTipt(strcmp('B0_regstop (ms)',{SCRPTipt.labelstr})).entrystr);
starttime = str2double(SCRPTipt(strcmp('B0_start (ms)',{SCRPTipt.labelstr})).entrystr);
est = str2double(SCRPTipt(strcmp('B0_est (ms)',{SCRPTipt.labelstr})).entrystr);

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
B0eddySub = B0eddy(ind1:ind2);

func = @(P,t) P(1)*exp(-t/P(2)); 
Est = [B0eddySub(1) est];
options = statset('Robust','off','WgtFun','');
[B0beta,resid,jacob,sigma,mse] = nlinfit(timeSub,B0eddySub,func,Est,options);
B0beta
ci = nlparci(B0beta,resid,'covar',sigma)

[SCRPTipt] = AddToPanelOutput(SCRPTipt,'B0_tc (ms)','0output',B0beta(2),'0numout');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'B0_mag (uT)','0output',B0beta(1),'0numout');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'B0_mag (%)','0output',B0beta(1)/Params.B0cal,'0numout');

step = 0.01;
if timeSub(length(timeSub)) > 10000
    step = 10;
elseif timeSub(length(timeSub)) > 1000
    step = 1;
elseif timeSub(length(timeSub)) > 100
    step = 0.1;
end
B0fit.interptime = (timeSub(1):step:timeSub(length(timeSub)));
B0fit.interpvals = B0beta(1)*(exp(-(B0fit.interptime)/B0beta(2)));
if regstart ~= starttime
    B0fit.interptime = B0fit.interptime + regstart;
end


