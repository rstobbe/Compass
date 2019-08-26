%======================================================
% 
%======================================================

function [PLOT,err] = PLOT_PSF_v1a_Func(PLOT,INPUT)

Status('busy','Plot PSF');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PSF = INPUT.PSF;
clear INPUT

%---------------------------------------------
% x-axis
%---------------------------------------------
%zf = 300;
zf = 1000;
xseg = PSF.PROJdgn.fov/zf;
x = (0:xseg:PSF.PROJdgn.fov-xseg) - PSF.PROJdgn.fov/2;

%---------------------------------------------
% FT
%---------------------------------------------
tf = PSF.tf;
sz = size(tf);
sz = sz(1)+1;
psf = zeros([zf zf zf]);
from = (zf-sz)/2+2;
to = zf-from+2;
psf(from:to,from:to,from:to) = tf;
%figure(1234)
%plot(psf(:,151,151));
psf = ifftshift(ifftn(fftshift(psf)));

%---------------------------------------------
% Shape Anlz
%---------------------------------------------
psf = psf/max(psf(:));

%---------------------------------------------
% Plot
%---------------------------------------------
fh = figure(200); hold on; box on;
PSFprof = squeeze(psf(:,length(psf)/2+1,length(psf)/2+1)); 
plot(x,abs(PSFprof),'k'); 
plot(x,real(PSFprof),'r'); 
plot(x,imag(PSFprof),'b'); 
plot(x,zeros(size(x)),'k');
%plot(imag(PSFprof),'b'); 
%PSFprof = squeeze(psf((length(psf)+1)/2,(length(psf)+1)/2,:)); 
%plot(PSFprof,'r:'); 
title('Point Spread Function'); 
%xlabel('Matrix Diameter'); 
xlabel('(mm)'); 
ylabel('Arb');
ylim([-0.1 1.05]); 
%xlim([-2.5 2.5]);
%xlim([0 1.5]);
fh.Units = 'inches';
fh.Position = [5 5 3 2.5];

%---------------------------------------------
% Return
%---------------------------------------------  
PLOT.ExpDisp = '';

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);