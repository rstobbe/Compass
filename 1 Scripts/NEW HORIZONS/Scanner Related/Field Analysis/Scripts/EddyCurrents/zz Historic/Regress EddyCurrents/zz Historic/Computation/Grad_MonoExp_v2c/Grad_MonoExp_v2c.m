%==================================
% (v2c)
%   - include 'gcal'
%==================================

function [SCRPTipt,SCRPTGBL,err] = Grad_MonoExp_v2c(SCRPTipt,SCRPTGBL)

err.flag = 0;
err.msg = '';

datastart = str2double(SCRPTipt(strcmp('data_start (ms)',{SCRPTipt.labelstr})).entrystr);
datastop = str2double(SCRPTipt(strcmp('data_stop (ms)',{SCRPTipt.labelstr})).entrystr);
starttime = str2double(SCRPTipt(strcmp('time_after_grad (ms)',{SCRPTipt.labelstr})).entrystr);
est = str2double(SCRPTipt(strcmp('estimate (ms)',{SCRPTipt.labelstr})).entrystr);

time = SCRPTGBL.Time;
Geddy = SCRPTGBL.Geddy;
gval = SCRPTGBL.gval;
gcal = SCRPTGBL.gcal;

ind1 = find(time>=datastart,1,'first');
ind2 = find(time<=datastop,1,'last');
if isempty(ind2)
    ind2 = length(time);
end
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
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'G_mag (uT/m)','0output',Gbeta(1)*1000,'0numout');
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'CompVal (V%)','0output',-100*gcal*Gbeta(1)/gval,'0numout');

step = 0.01;
if timeSub(length(timeSub)) > 10000
    step = 10;
elseif timeSub(length(timeSub)) > 1000
    step = 1;
elseif timeSub(length(timeSub)) > 100
    step = 0.1;
end
Gfit.interptime = (0:step:timeSub(length(timeSub)));
Gfit.interpvals = Gbeta(1)*(exp(-(Gfit.interptime)/Gbeta(2)));
Gfit.interptime = Gfit.interptime + datastart - starttime;

clr = 'r';
figure(1000); hold on;
plot([0 max(time)],[0 0],'k:'); 
plot(Gfit.interptime,Gfit.interpvals*1000,[clr,'-'],'linewidth',2);
plot(time,Geddy*1000,'k*');
ylim([-max(abs(Geddy*1000)) max(abs(Geddy*1000))]);
xlabel('(ms)'); ylabel('G Evolution (uT)'); xlim([0 max(time)]); title('Transient Field (G)');

