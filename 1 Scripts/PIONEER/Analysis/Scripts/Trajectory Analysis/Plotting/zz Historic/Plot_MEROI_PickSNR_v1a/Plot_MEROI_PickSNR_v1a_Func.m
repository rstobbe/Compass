%==================================================
% 
%==================================================

function [OUTPUT,err] = Plot_MEROI_PickSNR_v1a_Func(PLOT,INPUT)

Status('busy','Plot MEROI');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
OUTPUT = struct();

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
ANLZ = INPUT.ANLZ;
clear INPUT

Nob = ANLZ.Nob;
Nroi = ANLZ.Nroi;
Nsiv = ANLZ.Nsiv;
SP = ANLZ.SP;
snvr = PLOT.snvr;
snr = PLOT.snr;
colour = PLOT.colour;

%-----------------------------------------------------
% Calc
%-----------------------------------------------------
vox = (snr/snvr)/1000;
smnr = snr*sqrt(Nsiv);

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
figure(110); hold on;
plot(Nroi,smnr,colour);
OutStyle;

figure(111); hold on;
plot(Nroi,SP,colour);
OutStyle;

figure(210); hold on;
plot(Nroi*vox,smnr,colour);
xlabel('ROI Volume (cm3)'); ylabel('SMNR');
set(gca,'XScale','log');
xlim([1 16]);
set(gca,'xtick',[1 2 4 8 16]);
OutStyle;

figure(211); hold on;
plot(Nroi*vox,SP,colour);
xlabel('ROI Volume (cm3)'); ylabel('Acc');
set(gca,'XScale','log');
xlim([1 16]);
set(gca,'xtick',[1 2 4 8 16]);
OutStyle;


%==================================================
% 
%==================================================
function OutStyle
outstyle = 1;
if outstyle == 1
    set(gcf,'units','inches');
    set(gcf,'position',[3 3 3 3]);
    set(gcf,'paperpositionmode','auto');
    set(gca,'units','inches');
    set(gca,'position',[0.75 0.5 1.6 1.3]);
    set(gca,'fontsize',10,'fontweight','bold');
end