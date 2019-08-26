%==================================
% Monoexponential
%==================================

function [SCRPTipt,SCRPTGBL,err] = B0_MonoExpManual_v1a(SCRPTipt,SCRPTGBL)

err.flag = 0;
err.msg = '';

B0val = str2double(SCRPTipt(strcmp('B0 val (uT)',{SCRPTipt.labelstr})).entrystr);
tc = str2double(SCRPTipt(strcmp('tc (ms)',{SCRPTipt.labelstr})).entrystr);

time = SCRPTGBL.Time;
B0eddy = SCRPTGBL.B0eddy;
B0cal = SCRPTGBL.B0cal;
gval = SCRPTGBL.gval;

step = 0.01;
if time(length(time)) > 10000
    step = 10;
elseif time(length(time)) > 1000
    step = 1;
elseif time(length(time)) > 100
    step = 0.1;
end
interptime = (0:step:time(length(time)));
fitvals = B0val*(exp(-(time)/tc));
residvals = B0eddy*1000 - fitvals;
ifitvals = interp1(time,fitvals,interptime);
iresidvals = interp1(time,residvals,interptime);

clr = 'r';
figure(2000); hold on;
plot([0 max(time)],[0 0],'k:'); 
plot(interptime,ifitvals,[clr,':'],'linewidth',2);
plot(interptime,iresidvals,[clr,'-'],'linewidth',2);
plot(time,B0eddy*1000,'k*');
ylim([-max(abs(B0eddy*1000)) max(abs(B0eddy*1000))]);
xlabel('(ms)'); ylabel('B0 Evolution (uT)'); xlim([0 max(time)]); title('Transient Field (B0)');

[SCRPTipt] = AddToPanelOutput(SCRPTipt,'B0_mag (%)','0output',B0val/(B0cal*gval),'0numout');








