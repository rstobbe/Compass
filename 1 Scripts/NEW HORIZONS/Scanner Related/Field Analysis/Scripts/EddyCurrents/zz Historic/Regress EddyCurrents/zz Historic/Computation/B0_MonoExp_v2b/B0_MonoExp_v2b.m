%==================================
% Monoexponential
%==================================

function [SCRPTipt,SCRPTGBL,err] = B0_MonoExp_v2b(SCRPTipt,SCRPTGBL)

err.flag = 0;
err.msg = '';

datastart = str2double(SCRPTipt(strcmp('data_start (ms)',{SCRPTipt.labelstr})).entrystr);
datastop = str2double(SCRPTipt(strcmp('data_stop (ms)',{SCRPTipt.labelstr})).entrystr);
starttime = str2double(SCRPTipt(strcmp('time_after_grad (ms)',{SCRPTipt.labelstr})).entrystr);
est = str2double(SCRPTipt(strcmp('tc estimate (ms)',{SCRPTipt.labelstr})).entrystr);

time = SCRPTGBL.Time;
B0eddy = SCRPTGBL.B0eddy;
B0cal = SCRPTGBL.B0cal;
gval = SCRPTGBL.gval;

ind1 = find(time>=datastart,1,'first');
ind2 = find(time<=datastop,1,'last');
if isempty(ind2)
    ind2 = length(time);
end
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
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'B0_mag (uT)','0output',B0beta(1)*1000,'0numout');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'B0_mag (%)','0output',B0beta(1)*1000/(B0cal*gval),'0numout');

step = 0.01;
if timeSub(length(timeSub)) > 10000
    step = 10;
elseif timeSub(length(timeSub)) > 1000
    step = 1;
elseif timeSub(length(timeSub)) > 100
    step = 0.1;
end
B0fit.interptime = (0:step:timeSub(length(timeSub)));
B0fit.interpvals = B0beta(1)*(exp(-(B0fit.interptime)/B0beta(2)));
B0fit.interptime = B0fit.interptime + datastart - starttime;

clr = 'r';
figure(2000); hold on;
plot([0 max(time)],[0 0],'k:'); 
plot(B0fit.interptime,B0fit.interpvals*1000,[clr,'-'],'linewidth',2);
plot(time,B0eddy*1000,'k*');
ylim([-max(abs(B0eddy*1000)) max(abs(B0eddy*1000))]);
xlabel('(ms)'); ylabel('B0 Evolution (uT)'); xlim([0 max(time)]); title('Transient Field (B0)');

