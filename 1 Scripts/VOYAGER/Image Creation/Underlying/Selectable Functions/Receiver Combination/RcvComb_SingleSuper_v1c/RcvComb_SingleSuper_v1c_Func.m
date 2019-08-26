%=====================================================
%
%=====================================================

function [RCOMB,err] = RcvComb_SingleSuper_v1c_Func(RCOMB,INPUT)

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
clear INPUT;

%---------------------------------------------
% Test
%---------------------------------------------
[x,y,z,nrcvrs] = size(highresIms);            % x,y,z must be even...

%---------------------------------------------
% Transform to k-space
%---------------------------------------------
kdata = zeros(size(highresIms));
for n = 1:nrcvrs
    kdata(:,:,:,n) = fftshift(fftn(ifftshift(highresIms(:,:,:,n))));
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
if fwidz > z
    err.flag = 1;
    err.msg = 'RxProfRes smaller than acquired slice thickness';
    return
end
F0 = Kaiser_v1b(fwidx,fwidy,fwidz,RCOMB.proffilt,'unsym');
F = zeros(x,y,z);
F(x/2-fwidx/2+1:x/2+fwidx/2,y/2-fwidy/2+1:y/2+fwidy/2,z/2-fwidz/2+1:z/2+fwidz/2) = F0;
Status2('done','Create Filter',3);

%-------------------------------------------
% Create Low Resolution Images
%-------------------------------------------
lowresIms = zeros(size(kdata));
for n = 1:nrcvrs
    lowresIms(:,:,:,n) = fftshift(ifftn(ifftshift(kdata(:,:,:,n).*F)));
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
for n = 1:nrcvrs
    lowressq(:,:,:,n) = lowresIms(:,:,:,n).*conj(lowresIms(:,:,:,n));
end
lowresSOS = sum(lowressq,4);
clear lowressq;

%-------------------------------------------
% Create High-Low Res SOS Image
%-------------------------------------------
hlressq = zeros(size(highresIms));
for n = 1:nrcvrs
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



