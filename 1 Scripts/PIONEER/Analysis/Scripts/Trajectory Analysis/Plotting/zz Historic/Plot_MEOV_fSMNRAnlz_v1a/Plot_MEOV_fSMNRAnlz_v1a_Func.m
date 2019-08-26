%==================================================
% 
%==================================================

function [OUTPUT,err] = Plot_MEOV_fSMNRAnlz_v1a_Func(PLOT,INPUT)

Status('busy','Plot k-space from implementation');
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
snvr = PLOT.snvr;
smnr = PLOT.smnr;
colour = PLOT.colour

figure(10); 
plot(Nob,Nroi,'k-');
xlabel('Nob'); ylabel('Nroi');
set(gca,'XScale','log'); set(gca,'YScale','log');
xlim([16 512]); ylim([1 256]);
set(gca,'xtick',[16 32 64 128 256 512]);
set(gca,'ytick',[1 4 16 64 256]);
OutStyle;

figure(11); 
plot(Nroi,Nsiv,'k-');
xlabel('Nroi'); ylabel('Nsiv');
set(gca,'XScale','log'); set(gca,'YScale','log');
xlim([1 256]); ylim([1 256]);
set(gca,'xtick',[1 4 16 64 256]);
set(gca,'ytick',[1 4 16 64 256]);
OutStyle;

figure(12); 
plot(Nob,Nsiv,'k-');
xlabel('Nob'); ylabel('Nsiv');
set(gca,'XScale','log'); set(gca,'YScale','log');
xlim([16 512]); ylim([1 256]);
set(gca,'xtick',[16 32 64 128 256 512]);
set(gca,'ytick',[1 4 16 64 256]);
OutStyle;

%-----------------------------------------------------
% Calcs
%-----------------------------------------------------
fSMNRarr = 1./sqrt(Nsiv);
SNRarr = fSMNRarr*smnr;
Varr = (SNRarr/snvr)/1000;
MEOVarr = Varr.*Nob;

figure(20); 
plot(Nsiv,Nob.*Varr,'k-');
ylabel('Object Volume (mm3)'); xlabel('Nsiv');
set(gca,'XScale','log'); set(gca,'YScale','log');
ylim([2 32]); xlim([1 256]);
set(gca,'ytick',[2 4 8 16 32]);
set(gca,'xtick',[1 4 16 64 256]);
OutStyle;

figure(21); hold on;
plot(fSMNRarr,Nroi./Nob,colour);
xlabel('fSMNR'); ylabel('fROI');
set(gca,'XScale','log'); %set(gca,'YScale','log');
xlim([0.0625 1]); ylim([0 1]);
set(gca,'xtick',[0.0625 0.125 0.25 0.5 1]);
set(gca,'ytick',[0 0.2 0.4 0.6 0.8 1]);
OutStyle;

figure(22); hold on;
plot(fSMNRarr,MEOVarr,colour);
xlabel('fSMNR'); ylabel('MEOV');
set(gca,'XScale','log'); %set(gca,'YScale','log');
xlim([0.0625 1]); ylim([4 14]);
set(gca,'xtick',[0.0625 0.125 0.25 0.5 1]);
set(gca,'ytick',[4 6 8 10 12 14]);
OutStyle;

figure(23); hold on;
plot(fSMNRarr,Varr,colour);
xlabel('fSMNR'); ylabel('Voxel Volume (cm3)');
set(gca,'XScale','log'); set(gca,'YScale','log');
xlim([0.0625 1]); ylim([0.01 0.64]);
set(gca,'xtick',[0.0625 0.125 0.25 0.5 1]);
set(gca,'ytick',[0.01 0.04 0.16 0.64]);
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