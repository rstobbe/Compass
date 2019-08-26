%==================================
% Monoexponential
%==================================

function [SCRPTipt,SCRPTGBL,err] = SRext_v1a(SCRPTipt,SCRPTGBL)

err.flag = 0;
err.msg = '';

datastart = str2double(SCRPTipt(strcmp('data_start (ms)',{SCRPTipt.labelstr})).entrystr);
datastop = str2double(SCRPTipt(strcmp('data_stop (ms)',{SCRPTipt.labelstr})).entrystr);
smoothwin = str2double(SCRPTipt(strcmp('SmoothWinSR',{SCRPTipt.labelstr})).entrystr);

time = SCRPTGBL.Time;
Geddy = SCRPTGBL.Geddy;
gvals = SCRPTGBL.gvals;
graddel = SCRPTGBL.graddel;

ind1 = find(time>=datastart,1,'first');
ind2 = find(time<=datastop,1,'last');
if isempty(ind2)
    ind2 = length(time);
end

dwell = time(2) - time(1);
starttime = time(ind1);
duration = round((time(ind2) - time(ind1))*1000)/1000;
SRtime = (0:dwell:duration);
SR = Geddy(ind1:ind2);
iSRtime = (0:dwell/2:duration);
iSR = interp1(SRtime,SR,iSRtime);
iSRsmth = smooth(iSR,smoothwin,'loess');

SRvals = iSRsmth((2:2:length(iSRsmth)));

Gvis = []; L = [];
for n = 1:length(SRtime)-1
    L = [L [SRtime(n) SRtime(n+1)]];
    Gvis = [Gvis [SRvals(n) SRvals(n)]];
end

clr = 'r';
figure(1000); hold on;
plot([0 max(time)],[0 0],'k:'); 
plot(time,Geddy,'k-*');
plot(iSRtime+starttime,iSRsmth,'b-','linewidth',2);
plot([starttime L+starttime],[0 Gvis],[clr,'-'],'linewidth',2);
ylim([-0.1 max(abs(Geddy))]);
xlabel('(ms)'); ylabel('G Evolution (uT)'); xlim([time(ind1-5) time(ind2+5)]); title('Transient Field (G)');

SR.t = SRtime;
SR.G = SRvals;
SR.step = dwell;
SR.T = duration;
SR.N = length(SRtime);
SR.Gmax = max(gvals);
SR.Ginc = gvals(length(gvals)) - gvals(length(gvals)-1);
SR.Gmin = min(gvals);
SR.graddel = graddel;

%[SCRPTipt] = AddToPanelOutput(SCRPTipt,'G_tc (ms)','0output',Gbeta(2),'0numout');
%[SCRPTipt] = AddToPanelOutput(SCRPTipt,'G_mag (uT/m)','0output',Gbeta(1),'0numout');
%[SCRPTipt] = AddToPanelOutput(SCRPTipt,'G_mag (%)','0output',100*Gbeta(1)/gval,'0numout');


