%=====================================================
%
%=====================================================

function [RCOMB,err] = RcvComb_MultiSuper_v1b_Func(RCOMB,INPUT)

Status2('busy','Combine Receivers',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
highresIms = INPUT.Im;
vis = INPUT.vis;
lowresim = RCOMB.lowresim;
clear INPUT;

%---------------------------------------------
% Test
%---------------------------------------------
[x,y,z,nexp,rcvrs] = size(highresIms);            % x,y,z must be even...

%---------------------------------------------
% Transform to k-space
%---------------------------------------------
kdata = zeros(size(highresIms));
for m = 1:nexp
    for n = 1:rcvrs
        kdata(:,:,:,m,n) = fftshift(fftn(ifftshift(highresIms(:,:,:,m,n))));
    end
end

%-------------------------------------------
% Create Filter
%-------------------------------------------
fwidx = 2*ceil(x/6)+1;
fwidy = 2*ceil(y/6)+1;
fwidz = 2*ceil(z/6)+1;
beta = 12;
F0 = Kaiser(fwidx,fwidy,fwidz,beta);
F = zeros(x,y,z);
F(x/2-(fwidx+1)/2+2:x/2+(fwidx+1)/2,y/2-(fwidy+1)/2+2:y/2+(fwidy+1)/2,z/2-(fwidz+1)/2+2:z/2+(fwidz+1)/2) = F0;

%-------------------------------------------
% Create Low Resolution Images
%-------------------------------------------
lowresIms = zeros([x,y,z,rcvrs]);
for n = 1:rcvrs
    lowresIms(:,:,:,n) = fftshift(ifftn(ifftshift(kdata(:,:,:,lowresim,n).*F)));
    lowresIm = squeeze(abs(lowresIms(:,:,:,n)));
    lowresIm = lowresIm/(max(lowresIm(:)));
    if strcmp(vis,'Yes')
        figure(n); imshow(squeeze(lowresIm(:,:,z/2))); drawnow;
    end
end
    
%-------------------------------------------
% Create Low Res SOS Image
%-------------------------------------------
lowressq = zeros(size(lowresIms));
for n = 1:rcvrs
    lowressq(:,:,:,n) = lowresIms(:,:,:,n).*conj(lowresIms(:,:,:,n));
end
lowresSOS = sum(lowressq,4);
clear lowressq;

%-------------------------------------------
% Create High-Low Res SOS Image
%-------------------------------------------
hlressq = zeros(size(highresIms));
for m = 1:nexp
    for n = 1:rcvrs
        hlressq(:,:,:,m,n) = highresIms(:,:,:,m,n).*conj(lowresIms(:,:,:,n));
    end
end
hlresSOS = squeeze(sum(hlressq,5));
clear hlressq;
clear highresIms; 
clear lowresIms;

%-------------------------------------------
% Combine
%-------------------------------------------
Im = zeros([x,y,z,nexp]);
for m = 1:nexp
    Im(:,:,:,m) = (sqrt(lowresSOS)./lowresSOS).*hlresSOS(:,:,:,m);
end

%---------------------------------------------
% Return
%---------------------------------------------
RCOMB.Im = Im;

Status2('done','',2);
Status2('done','',3);



