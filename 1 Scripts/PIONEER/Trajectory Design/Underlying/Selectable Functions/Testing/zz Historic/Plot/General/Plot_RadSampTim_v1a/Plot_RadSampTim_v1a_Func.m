
%=========================================================
% 
%=========================================================

function [OUTPUT,err] = Plot_RadSampTim_v1a_Func(INPUT)

Status('busy','Plot Radial Sampling Timing');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
OUTPUT = struct();

%---------------------------------------------
% Get Input
%---------------------------------------------
DES = INPUT.DES;
T = DES.T;
KSA = DES.KSA;
PROJdgn = DES.PROJdgn;
rad = PROJdgn.rad;
clear INPUT;

%--------------------------------------------
% Get SD Shape
%--------------------------------------------
KSA = squeeze(KSA);
r = sqrt(KSA(:,1).^2 + KSA(:,2).^2 + KSA(:,3).^2);

%--------------------------------------------
% Plot 
%--------------------------------------------
figure(40); hold on; 
plot(T,r,'k','linewidth',2); xlim([0 T(length(T))]); 
xlabel('Sampling Time'); 
ylabel('Relative Radial Dimension'); 
title('Radial Sampling Timing');

%--------------------------------------------
% Plot 
%--------------------------------------------
figure(41); hold on; 
plot(T,r*rad,'k','linewidth',2); xlim([0 T(length(T))]); 
xlabel('Sampling Time'); 
ylabel('Sampling Radial Dimension'); 
title('Radial Sampling Timing');
