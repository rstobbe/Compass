%===========================================
% 
%===========================================

function [FILT,err] = FilterImageKaiser2D_v1a_Func(FILT,INPUT)

Status2('busy','Create Filter',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
Im = INPUT.Im;
ReconPars = INPUT.ReconPars;
clear INPUT;

%---------------------------------------------
% Create Filter
%--------------------------------------------- 
sz = size(Im);                        
Filt = Kaiser2D_v1b(sz(1),sz(2),FILT.beta,'unsym');
%figure(100); hold on;
%plot(squeeze(Filt(sz(1)/2+1,:)));
%plot(squeeze(Filt(:,sz(2)/2+1)));

%---------------------------------------------
% Add Filter
%--------------------------------------------- 
for m = 1:sz(3)
    Im(:,:,m) = fftshift(fft2(ifftshift(Filt.*fftshift(ifft2(ifftshift(Im(:,:,m)))))));
end

%---------------------------------------------
% Update ReconPars
%--------------------------------------------- 
ReconPars.Filter = ['Kaiser',num2str(FILT.beta)];
FILT.ReconPars = ReconPars;

%---------------------------------------------
% Return
%--------------------------------------------- 
FILT.Im = Im;

Status2('done','',2);
Status2('done','',3);

