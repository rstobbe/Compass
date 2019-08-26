%==================================================
% 
%==================================================

function [PLOT,err] = Plot_TrajTest_v1a_Func(PLOT,INPUT)

Status('busy','Plot Trajectory Test');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
EDDY = INPUT.EDDY;
IMP = INPUT.IMP;
clr = PLOT.clr;
clear INPUT

%-----------------------------------------------------
% Get Transient Field Info
%-----------------------------------------------------
Time = EDDY.Time;
Geddy = EDDY.Geddy;
B0eddy = EDDY.B0eddy;

%-----------------------------------------------------
% Get Gradient Info
%-----------------------------------------------------
qTscnr = IMP.qTscnr;
G = IMP.G;
trajno = PLOT.trajnum;
dir = PLOT.trajortho;
if strcmp(PLOT.gpol,'Neg')
    Geddy = -Geddy;
end

Time = Time + PLOT.gstartshift/1000;

%-----------------------------------------------------
% Traj Vis
%-----------------------------------------------------
Gvis = []; L = [];
for n = 1:length(qTscnr)-1
    L = [L [qTscnr(n) qTscnr(n+1)]];
    Gvis = [Gvis [squeeze(G(trajno,n,dir)) squeeze(G(trajno,n,dir))]];
end

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
figure(1000); hold on; 
plot([0 max(Time)],[0 0],'k:');  
plot(L,squeeze(Gvis),'k-');
plot(Time,Geddy,clr);    
xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); title('Transient Field (Gradient)'); OutStyle;
xlim([0 Time(length(Time))])

figure(1001); hold on; 
plot([0 max(Time)],[0 0],'k:'); 
plot(L,10*squeeze(Gvis)/max(Gvis(:)),'k-');
plot(Time,B0eddy*1000,clr);
%ylim([-10 10]);
xlabel('(ms)'); ylabel('B0 Evolution (uT)'); title('Transient Field (B0)'); OutStyle;



    
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