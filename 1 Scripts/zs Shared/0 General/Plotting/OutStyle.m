%==================================================
% 
%==================================================
function OutStyle(style)
if style == 1
    set(gcf,'units','inches');
    set(gcf,'position',[3 3 3 3]);
    set(gcf,'paperpositionmode','auto');
    set(gca,'units','inches');
    set(gca,'position',[0.75 0.5 1.6 1.3]);
    set(gca,'fontsize',10,'fontweight','bold');
    box on;
elseif style == 2
    set(gcf,'units','inches');
    set(gcf,'position',[3 3 3 3]);
    set(gcf,'paperpositionmode','auto');
    set(gca,'units','inches');
    set(gca,'position',[0.75 0.5 2 1.3]);
    set(gca,'fontsize',10,'fontweight','bold');
    box on;
elseif style == 3
    set(gcf,'units','inches');
    set(gcf,'position',[3 3 3.5 3]);
    set(gcf,'paperpositionmode','auto');
    set(gca,'units','inches');
    set(gca,'position',[0.75 0.5 2.2 1.8]);
    set(gca,'fontsize',10,'fontweight','bold');
    box on;
end