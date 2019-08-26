%==================================================
% 
%==================================================

function [OUTPUT,err] = Plot_MEROI_ArrAnlz_v1a_Func(PLOT,INPUT)

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
smnr = PLOT.smnr;
colour = PLOT.colour;

%-----------------------------------------------------
% Interp Acc
%-----------------------------------------------------
accArr = (0.5:0.01:0.9);
NroiAcc = interp1(SP,Nroi,accArr);
NsivAcc = interp1(SP,Nsiv,accArr);
fSMNR = 1./sqrt(NsivAcc);
SNR = fSMNR*smnr;
Varr = (SNR/snvr)/1000;
MEROI = Varr.*NroiAcc;

figure(10); hold on;
plot(accArr,fSMNR,colour);
xlabel('AccArr'); ylabel('fSMNR');
xlim([0.5 0.9]); ylim([0 0.3]);
title('fSMNR associated with MEROI');
OutStyle;

figure(11); hold on;
plot(accArr,MEROI,colour);
xlabel('AccArr'); ylabel('MEROI');
xlim([0.5 0.9]); ylim([1 20]);
title('MEROI if fSMNR (in fig 10) used');
OutStyle;

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
figure(20); hold on;
plot(Nroi,SP,colour);
xlabel('Nroi'); ylabel('SP');
OutStyle;

figure(21); hold on;
plot(Nroi,Nsiv,colour);
xlabel('NroiVol'); ylabel('Nsiv');
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