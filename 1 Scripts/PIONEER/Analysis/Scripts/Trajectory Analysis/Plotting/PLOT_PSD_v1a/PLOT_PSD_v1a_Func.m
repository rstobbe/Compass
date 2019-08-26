%======================================================
% 
%======================================================

function [PLOT,err] = PLOT_PSD_v1a_Func(PLOT,INPUT)

Status('busy','Plot PSD');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PSD = INPUT.PSD;
clear INPUT

%---------------------------------------------
% Plot
%---------------------------------------------
psd = PSD.psd;
figure(200); hold on;
PSDprof = squeeze(psd(:,(length(psd)+1)/2,(length(psd)+1)/2)); plot(PSDprof,'r'); 
PSDprof = squeeze(psd((length(psd)+1)/2,(length(psd)+1)/2,:)); plot(PSDprof,'r:'); 
title('PSD Function'); xlabel('Matrix Diameter'); ylabel('Arb');
ylim([0 max(PSDprof(:))*1.1]); xlim([1 length(PSDprof)]);    

%---------------------------------------------
% Return
%---------------------------------------------  
PLOT.ExpDisp = '';

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);