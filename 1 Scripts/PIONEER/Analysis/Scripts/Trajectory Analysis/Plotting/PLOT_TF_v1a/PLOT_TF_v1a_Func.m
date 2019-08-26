%======================================================
% 
%======================================================

function [PLOT,err] = PLOT_TF_v1a_Func(PLOT,INPUT)

Status('busy','Plot PSF');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PSF = INPUT.PSF;
PROJdgn = PSF.PROJdgn;
clear INPUT

%---------------------------------------------
% Plot
%---------------------------------------------
sz = size(PSF.tf);
sz = sz(1)+1;
%--
zf = 80;
%--
tf = zeros([zf zf zf]);
from = (zf-sz)/2+1;
to = zf-from;
tf(from:to,from:to,from:to) = PSF.tf;

kval = 1000*(-zf/2+1:zf/2)/PROJdgn.fov;

fh = figure(200); hold on; box on;
TFprof = squeeze(tf(:,length(tf)/2,length(tf)/2)); plot(kval,TFprof,'r'); 
%TFprof = squeeze(tf(length(tf)/2,length(tf)/2,:)); plot(TFprof,'r:'); 
title('Transfer Function'); xlabel('kSpace (1/m)'); ylabel('Relative Value');
%ylim([0 max(TFprof(:))*1.1]); xlim([1 length(TFprof)]);    
ylim([0.6 1.05]);
xlim([-40 40]);
fh.Units = 'inches';
fh.Position = [5 5 3 2.5];

%---------------------------------------------
% Return
%---------------------------------------------  
PLOT.ExpDisp = '';

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);