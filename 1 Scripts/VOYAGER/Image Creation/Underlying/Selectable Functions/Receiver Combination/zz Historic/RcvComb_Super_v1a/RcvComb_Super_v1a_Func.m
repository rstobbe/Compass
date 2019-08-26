%=====================================================
%
%=====================================================

function [RCOMB,err] = RcvComb_Super_v1a_Func(RCOMB,INPUT)

Status2('busy','Combine Receivers',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
kdata = INPUT.FIDmat;
vis = INPUT.vis;
clear INPUT;

%-------------------------------------------
% Create Filter
%-------------------------------------------
[x,y,z,rcvrs] = size(kdata);            % x,y,z must be even...
fwidx = 2*ceil(x/6)+1;
fwidy = 2*ceil(y/6)+1;
fwidz = 2*ceil(z/6)+1;
beta = 12;
F0 = Kaiser(fwidx,fwidy,fwidz,beta);

%-------------------------------------------
% Filter
%-------------------------------------------
xinc = 2*ceil(x/2);     % fov increase hold over (ensure even...)
yinc = 2*ceil(y/2);
zinc = 2*ceil(z/2);
if xinc ~= x || yinc ~= y || zinc ~= z
    error()
end
ImFovInc = zeros(xinc,yinc,zinc);
kdata2 = zeros(xinc,yinc,zinc,rcvrs);
for n = 1:rcvrs
    Im = fftshift(ifftn(ifftshift(kdata(:,:,:,n))));
    ImFovInc(xinc/2-x/2+1:xinc/2+x/2,yinc/2-y/2+1:yinc/2+y/2,zinc/2-z/2+1:zinc/2+z/2) = Im;
    kdata2(:,:,:,n) = fftshift(fftn(ifftshift(ImFovInc)));
end

F = zeros(xinc,yinc,zinc);
F(xinc/2-(fwidx+1)/2+2:xinc/2+(fwidx+1)/2,yinc/2-(fwidy+1)/2+2:yinc/2+(fwidy+1)/2,zinc/2-(fwidz+1)/2+2:zinc/2+(fwidz+1)/2) = F0;

%-------------------------------------------
% Create Low Resolution Images
%-------------------------------------------
lowresIms = zeros(size(kdata2));
highresIms = zeros(size(kdata2));
for n = 1:rcvrs
    highresIms(:,:,:,n) = fftshift(ifftn(ifftshift(kdata2(:,:,:,n))));
    lowresIms(:,:,:,n) = fftshift(ifftn(ifftshift(kdata2(:,:,:,n).*F)));
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
for n = 1:rcvrs
    hlressq(:,:,:,n) = highresIms(:,:,:,n).*conj(lowresIms(:,:,:,n));
end
hlresSOS = sum(hlressq,4);
clear hlressq;
clear highresIms; 
clear lowresIms;

%-------------------------------------------
% Combine
%-------------------------------------------
Im = (sqrt(lowresSOS)./lowresSOS).*hlresSOS;

%---------------------------------------------
% Return
%---------------------------------------------
RCOMB.Im = Im;

Status2('done','',2);
Status2('done','',3);



