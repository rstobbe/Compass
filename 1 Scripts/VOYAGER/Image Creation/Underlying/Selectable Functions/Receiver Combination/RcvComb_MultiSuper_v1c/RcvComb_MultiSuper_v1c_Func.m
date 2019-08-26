%=====================================================
%
%=====================================================

function [RCOMB,err] = RcvComb_MultiSuper_v1c_Func(RCOMB,INPUT)

Status2('busy','Combine Receivers',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
highresIms = INPUT.Im;
vis = INPUT.vis;
ReconPars = INPUT.ReconPars;
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
Status2('busy','Create Filter',3);
fwidx = 2*round((ReconPars.Imfovro/RCOMB.profres)/2);
fwidy = 2*round((ReconPars.Imfovpe1/RCOMB.profres)/2);
if isfield(ReconPars,'Imfovpe2')
    fwidz = 2*round((ReconPars.Imfovpe2/RCOMB.profres)/2);
else
    fwidz = 2*round((ReconPars.Imfovslc/RCOMB.profres)/2);
end
F0 = Kaiser_v1b(fwidx,fwidy,fwidz,RCOMB.proffilt,'unsym');
F = zeros(x,y,z);
F(x/2-fwidx/2+1:x/2+fwidx/2,y/2-fwidy/2+1:y/2+fwidy/2,z/2-fwidz/2+1:z/2+fwidz/2) = F0;
Status2('done','Create Filter',3);

%-------------------------------------------
% Create Low Resolution Images
%-------------------------------------------
lowresIms = zeros([x,y,z,rcvrs]);
for n = 1:rcvrs
    lowresIms(:,:,:,n) = fftshift(ifftn(ifftshift(kdata(:,:,:,lowresim,n).*F)));
    lowresIm = squeeze(abs(lowresIms(:,:,:,n)));
    lowresIm = lowresIm/(max(lowresIm(:)));
    if strcmp(vis,'Yes')
        IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = 1; IMSTRCT.stop = z; 
        IMSTRCT.rows = floor(sqrt(z)+1); IMSTRCT.lvl = [0 1]; IMSTRCT.SLab = 0; IMSTRCT.figno = 5000+n; 
        IMSTRCT.docolor = 1; IMSTRCT.ColorMap = 'ColorMap4'; IMSTRCT.figsize = [];
        AxialMontage_v2a(lowresIm,IMSTRCT);  
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



