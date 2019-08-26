%==============================================
% 
%==============================================

function [CVCALC,err] = CorVolCalc_v1a(CVCALC,INPUT)

Status2('busy','Calculate Correlation Volume',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Common Variables
%---------------------------------------------
roi = INPUT.roi;
psd = INPUT.psd;
kmatvol = INPUT.kmatvol;
clear INPUT

%---------------------------------------------
% CV FT-method
%---------------------------------------------
mroi = sum(roi(:));
ftroi = fftshift(fftn(ifftshift(double(roi))));

% sz = size(ftroi);
% figure(1000); hold on
% plot(abs(ftroi(:,sz(2)/2+1,sz(3)/2+1))/max(abs(ftroi(:))),'r');         
% plot(psd(:,sz(2)/2+1,sz(3)/2+1)/max(abs(psd(:))),'b');
% figure(1001); hold on
% plot(abs(squeeze(ftroi(sz(1)/2+1,sz(2)/2+1,:)))/max(abs(ftroi(:))),'r');         
% plot(squeeze(psd(sz(1)/2+1,sz(2)/2+1,:))/max(abs(psd(:))),'b');

temp = ftroi.*psd;
clear ftroi;                % memory

% figure(1000); hold on
% plot(abs(temp(:,sz(2)/2+1,sz(3)/2+1))/max(abs(temp(:))),'c');         
% figure(1001); hold on
% plot(abs(squeeze(temp(sz(1)/2+1,sz(2)/2+1,:)))/max(abs(temp(:))),'c');         

cvunscale = fftshift(ifftn(ifftshift(temp)));
clear temp;                  % memory
test = sum(imag(cvunscale(:)));                                                     % should be ~ zero
if test > 1e-16
    test
    error;
end
cvunscale = real(cvunscale);

% figure(2000); hold on
% plot(roi(:,sz(2)/2+1,sz(3)/2+1),'r');
% plot(cvunscale(:,sz(2)/2+1,sz(3)/2+1)/max(cvunscale(:)),'c');         
% figure(2001); hold on
% plot(squeeze(roi(sz(1)/2+1,sz(2)/2+1,:)),'r');
% plot(squeeze(cvunscale(sz(1)/2+1,sz(2)/2+1,:))/max(cvunscale(:)),'c');        

aroi = cvunscale(logical(roi));
CVCALC.cv = (kmatvol/sum(psd(:)))*(sum(aroi(:))./mroi);

Status2('done','',3);
