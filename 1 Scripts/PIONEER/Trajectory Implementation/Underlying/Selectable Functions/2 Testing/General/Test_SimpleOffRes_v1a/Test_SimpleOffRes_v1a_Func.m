%==================================================
% 
%==================================================

function [OUTPUT,err] = Test_SimpleOffRes_v1a_Func(PLOT,INPUT)

Status2('busy','Plot k-Space (3D)',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
OUTPUT = struct();

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
IMP = INPUT.IMP;
PROJdgn = IMP.DES.PROJdgn;
samp = IMP.samp;
Kmat = IMP.Kmat;
clear INPUT

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
samp = samp - samp(1);
rad = sqrt(Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2);
rad = squeeze(mean(rad,1));
rad = rad/max(rad);

Off = 0.4;      %kHz
phase = exp(1i*2*pi*Off*samp);

% fh = figure(1000); hold on; box on;
% plot(rad,real(phase),'k-');
% title('Phase Evolution');
% xlabel('Relative k-Space Radius','fontsize',10,'fontweight','bold');
% ylabel('Phase','fontsize',10,'fontweight','bold');

TF = interp1(rad,phase,(0.001:0.001:0.999));
plot((0.001:0.001:0.999),real(TF),'b')

TF = [1 TF zeros(1,18001) flip(TF,2)];
figure(1001); hold on;
plot(real(TF));
plot(imag(TF));

PSF = ifftshift(ifft(TF));
figure(1002); hold on;
plot((0:0.1:1999.9),abs(PSF),'k');
plot((0:0.1:1999.9),real(PSF),'r');
plot((0:0.1:1999.9),imag(PSF),'b');
xlim([960 1040]);

