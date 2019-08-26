%==================================================
% 
%==================================================

function [PLOT,err] = Plot_SingleGradTestFile_v1a_Func(INPUT,PLOT)

Status('busy','Plot Transient Fields During/After Gradient');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
OUTPUT = struct();

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
GRD = INPUT.GRD;
clear INPUT;
clr = PLOT.clr;

%-----------------------------------------------------
% Get Gradient Info
%-----------------------------------------------------
T = GRD.T;
G = GRD.G;
L = GRD.L;
Gvis = GRD.Gvis;

%-----------------------------------------------------
% Plot Through Middle
%-----------------------------------------------------
T = T + T(2)/2;

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
figure(1000); hold on;    
plot(T,squeeze(G),clr);
plot(L,squeeze(Gvis),clr);
xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); title('Transient Field (Gradient)'); OutStyle;
   
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