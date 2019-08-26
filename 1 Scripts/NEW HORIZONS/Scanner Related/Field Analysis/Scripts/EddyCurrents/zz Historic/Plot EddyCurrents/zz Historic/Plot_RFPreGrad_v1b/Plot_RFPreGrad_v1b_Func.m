%==================================================
% 
%==================================================

function [OUTPUT,err] = Plot_RFPreGrad_v1b_Func(PLOT)

Status('busy','Plot Transient Fields During/After Gradient');
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
gradend = GRD.graddur;

%-----------------------------------------------------
% Get Transient Field Info
%-----------------------------------------------------
EDDY = PLOT.EDDY;
Time = EDDY.Time;
Geddy = EDDY.Geddy;
B0eddy = EDDY.B0eddy;
B0cal = EDDY.B0cal;
gval = EDDY.gval;
rB0cal = B0cal*gval;

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
if strcmp(type,'Abs_Full')
    figure(1000); hold on; 
    plot([0 max(Time)],[0 0],'k:'); 
    plot(Time,Geddy,clr);     
    plot(GRD.T,squeeze(GRD.G),'b-');
    plot(L,squeeze(Gvis),'b-');
    %ylim([-max(abs(Geddy)) max(abs(Geddy))]);
    %ylim([-1 0.2]); xlim([10.6 11.5]);
    xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); title('Transient Field (Gradient)'); OutStyle;
    figure(1001); hold on; 
    plot([0 max(Time)],[0 0],'k:'); 
    plot(Time,B0eddy*1000,clr);
    %plot(L,-10*Gvis/max(Gvis),'b-');
    plot(L,10*Gvis/max(Gvis),'b-');
    ylim([-1 1]);
    xlabel('(ms)'); ylabel('B0 Evolution (uT)'); title('Transient Field (B0)'); OutStyle;
    
elseif strcmp(type,'Relative_1msTC')
    figure(1000); hold on; 
    plot([0 max(Time)],[0 0],'k:'); 
    Time = Time - gradend;
    plot(Time,100*Geddy/gval,clr); 
    ylim([-0.25 0.25]); xlim([0 20]);
    xlabel('(ms)'); ylabel('Gradient Evolution (%)'); title('Transient Field (Gradient)'); OutStyle;
    figure(1001); hold on; 
    plot([0 max(Time)],[0 0],'k:'); 
    plot(Time,B0eddy*1000/gval,clr);
    ylim([-0.1 0.1]); xlim([0 20]);
    xlabel('(ms)'); ylabel('B0 Evolution (uT)/(mT/m)'); title('Transient Field (B0)');  OutStyle;
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