%======================================================
% 
%======================================================

function [PSF,err] = CreatePSFProfile_v1a_Func(PSF,INPUT)

Status('busy','Create PSF');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
TF = INPUT.TF;
TFS = TF.TFS;
zf = PSF.zf;
clear INPUT

xseg = TF.PROJdgn.fov/zf;
PSF.x = (0:xseg:TF.PROJdgn.fov-xseg) - TF.PROJdgn.fov/2;
if isfield(TFS,'scaledown')
    PSF.x = PSF.x/TFS.scaledown;
end

%---------------------------------------------
% FT
%---------------------------------------------
%-
% tf0 = TF.tf;
% tf = zeros(size(tf0));
% tf(tf0 > 0.005) = 1;
%-
tf = TF.tf;
sz = size(tf);
sz = sz(1)+1;
psf = zeros([zf zf zf]);
from = (zf-sz)/2+2;
to = zf-from+2;
psf(from:to,from:to,from:to) = tf;
psf = ifftshift(ifftn(fftshift(psf)));

%--
%psf = psf/max(psf(:));
%--

%---------------------------------------------
% Return
%---------------------------------------------  
PSF.psfprof1 = squeeze(psf(:,length(psf)/2+1,length(psf)/2+1));
PSF.psfprof2 = squeeze(psf(length(psf)/2+1,:,length(psf)/2+1));
PSF.psfprof3 = squeeze(psf(length(psf)/2+1,length(psf)/2+1,:));
PSF.ExpDisp = '';

%---------------------------------------------
% Plot
%---------------------------------------------
fh = figure(200); hold on; box on;
%plot(PSF.x,abs(PSF.psfprof1),'k'); 
plot(PSF.x,real(PSF.psfprof1),'r'); 
%plot(PSF.x,imag(PSF.psfprof1),'b'); 
% plot(PSF.x,abs(PSF.psfprof3),'k'); 
% plot(PSF.x,real(PSF.psfprof3),'r'); 
% plot(PSF.x,imag(PSF.psfprof3),'b'); 
plot(PSF.x,zeros(size(PSF.x)),'k');
title('Point Spread Function'); 
xlabel('(mm)'); 
ylabel('Arb');
%ylim([-0.1 1.05]); 
ylim([-5 40]*1e-6); 
xlim([-20 20]);
%xlim([0 1.5]);
fh.Units = 'inches';
fh.Position = [5 5 3 2.5];

%---------------------------------------------
% FVHM
%---------------------------------------------
hProf1 = abs(PSF.psfprof1(1:length(psf)/2+1));
hx = PSF.x(1:length(psf)/2+1);
%plot(hx,hProf1,'m');

HW = interp1(hProf1,hx,hProf1(end)/2);
TW = interp1(hProf1,hx,hProf1(end)/3);
QW = interp1(hProf1,hx,hProf1(end)/4);
%plot(HW,hProf1(end)/2,'*');
%plot(TW,hProf1(end)/3,'*');
%plot(QW,hProf1(end)/4,'*');
FWHM = 2*abs(HW)
FVHM = pi*4/3*(abs(HW)^3)
FVTM = pi*4/3*(abs(TW)^3)
FVQM = pi*4/3*(abs(QW)^3)

PSF.FWHM = FWHM;
save('PsfProfiles','PSF');

%---------------------------------------------
% ConvTest
%---------------------------------------------
% figure(201); hold on; box on;
% ObWid = ceil(1/xseg);
% ObWidmm = ObWid*xseg
% Ob = zeros(1,length(psf));
% mid = length(psf)/2 - ceil(ObWid/2) - 1;
% Ob(mid:mid+ObWid-1) = 1;
% Ob(mid+2*ObWid:mid+3*ObWid-1) = 1;
% plot(PSF.x,Ob,'k');
% test = conv(PSF.psfprof1,Ob,'same')/abs(sum(PSF.psfprof1));
% plot(PSF.x,real(test),'r');
% plot(PSF.x,imag(test),'b');
% plot(PSF.x,abs(test),'k');


Status2('done','',1);
Status2('done','',2);
Status2('done','',3);