
%=========================================================
% 
%=========================================================

function [OUTPUT,err] = Plot_ImpRadSampTim_v1a_Func(INPUT)

Status('busy','Plot Imp Radial Sampling Timing');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
OUTPUT = struct();

%---------------------------------------------
% Get Input
%---------------------------------------------
IMP = INPUT.IMP;
Kmat = IMP.Kmat;
T = IMP.samp;
PROJdgn = IMP.PROJdgn;
rad = PROJdgn.rad;
clear INPUT;

%--------------------------------------------
% Get SD Shape
%--------------------------------------------
r = sqrt(Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2);
r = mean(r,1);

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
