%==================================================
% 
%==================================================

function [SCRPTipt,SCRPTGBL,err] = Plot_MultiTFDiscrete_v1a(SCRPTipt,SCRPTGBL)

err.flag = 0;
err.msg = '';

clr = SCRPTipt(strcmp('Colour',{SCRPTipt.labelstr})).entrystr;
if iscell(clr)
    clr = SCRPTipt(strcmp('Colour',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('Colour',{SCRPTipt.labelstr})).entryvalue};
end

type = SCRPTipt(strcmp('Type',{SCRPTipt.labelstr})).entrystr;
if iscell(type)
    type = SCRPTipt(strcmp('Type',{SCRPTipt.labelstr})).entrystr{SCRPTipt(strcmp('Type',{SCRPTipt.labelstr})).entryvalue};
end

Time = SCRPTGBL.Time;
Geddy = SCRPTGBL.Geddy;
B0eddy = SCRPTGBL.B0eddy;
B0cal = SCRPTGBL.B0cal;
gval = SCRPTGBL.gval;

rB0cal = B0cal*gval;

if length(Geddy(:,1)) > 1
    err.flag = 1;
    err.msg = 'Use Multiple TF Plotting';
    return
end

if strcmp(type,'Abs')
    figure(1000); hold on; 
    plot([0 max(Time)],[0 0],'k:'); 
    plot(Time,Geddy*1000,[clr,'*']);     
    ylim([-max(abs(Geddy*1000)) max(abs(Geddy*1000))]);
    xlabel('(ms)'); ylabel('Gradient Evolution (uT/m)'); xlim([0 max(Time)]); title('Transient Field (Gradient)');

    figure(1001); hold on; 
    plot([0 max(Time)],[0 0],'k:'); 
    plot(Time,B0eddy*1000,[clr,'*']); 
    ylim([-max(abs(B0eddy*1000)) max(abs(B0eddy*1000))]);
    xlabel('(ms)'); ylabel('B0 Evolution (uT)'); xlim([0 max(Time)]); title('Transient Field (B0)');
elseif strcmp(type,'Percent')
    figure(1000); hold on; 
    plot([0 max(Time)],[0 0],'k:'); 
    plot(Time,100*Geddy/gval,[clr,'*']);     
    ylim([-max(abs(100*Geddy/gval)) max(abs(100*Geddy/gval))]);
    xlabel('(ms)'); ylabel('Gradient Evolution (%)'); xlim([0 max(Time)]); title('Transient Field (Gradient)');

    figure(1001); hold on; 
    plot([0 max(Time)],[0 0],'k:'); 
    plot(Time,B0eddy*1000/rB0cal,[clr,'*']);
    ylim([-max(abs(B0eddy*1000/rB0cal)) max(abs(B0eddy*1000/rB0cal))]);
    xlabel('(ms)'); ylabel('B0 Evolution (%)'); xlim([0 max(Time)]); title('Transient Field (B0)');
end
    
outstyle = 0;
if outstyle == 1
    set(gcf,'units','inches');
    set(gcf,'position',[4 4 4 4]);
    set(gcf,'paperpositionmode','auto');
    set(gca,'units','inches');
    set(gca,'position',[0.75 0.5 2.5 2.5]);
    set(gca,'fontsize',10,'fontweight','bold');
end