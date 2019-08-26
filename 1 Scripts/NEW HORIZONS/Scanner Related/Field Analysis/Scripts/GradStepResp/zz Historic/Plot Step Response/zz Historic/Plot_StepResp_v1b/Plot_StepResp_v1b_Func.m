%==================================================
% 
%==================================================

function [OUTPUT,err] = Plot_StepResp_v1b_Func(PLOT)

Status('busy','Plot Step Response');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
OUTPUT = struct();

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
clr = PLOT.clr;
type = PLOT.type;

%-----------------------------------------------------
% Get Gradient Info
%-----------------------------------------------------
GRD = PLOT.GRD;
L = GRD.L;
Gvis = GRD.Gvis;

%-----------------------------------------------------
% Get Transient Field Info
%-----------------------------------------------------
EDDY = PLOT.EDDY;
Time = EDDY.Time;
Geddy = EDDY.Geddy;

Geddy = -Geddy;

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
if strcmp(type,'Abs_Full')
    figure(1000); hold on; 
    plot([0 max(Time)],[0 0],'k:'); 
    for n = 1:length(Geddy(:,1));
        plot(Time,Geddy(n,:),clr);
        plot(L,Gvis(n,:),'b-');
    end
    xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); title('Transient Field (Gradient)'); OutStyle;
end

%===============================================
function OutStyle
outstyle = 0;
if outstyle == 1
    set(gcf,'units','inches');
    set(gcf,'position',[4 4 4 4]);
    set(gcf,'paperpositionmode','auto');
    set(gca,'units','inches');
    set(gca,'position',[0.75 0.5 2.5 2.5]);
    set(gca,'fontsize',10,'fontweight','bold');
    box on;
end