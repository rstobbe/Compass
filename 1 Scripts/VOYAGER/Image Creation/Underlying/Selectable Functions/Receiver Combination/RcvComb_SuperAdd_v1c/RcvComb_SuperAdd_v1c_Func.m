%=====================================================
%
%=====================================================

function [RCOMB,err] = RcvComb_SuperAdd_v1c_Func(RCOMB,INPUT)

Status2('busy','Combine Receivers',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
holdIms = INPUT.Im;
highresIms = INPUT.Im;
ReconPars = INPUT.ReconPars;
clear INPUT;

%---------------------------------------------
% Test
%---------------------------------------------
% if length(size(highresIms)) ~= 5
%     err.flag = 1;
%     err.msg = 'Do not have 5D data';
%     return
% end

[x,y,z,nexp,rcvrs] = size(highresIms);            % x,y,z must be even...

%---------------------------------------------
% Transform to k-space
%---------------------------------------------
kdata = complex(zeros(size(highresIms)),zeros(size(highresIms)));
for m = 1:nexp
    for n = 1:rcvrs
        kdata(:,:,:,m,n) = fftshift(fftn(ifftshift(highresIms(:,:,:,m,n))));
    end
end

%-------------------------------------------
% Create Filter
%-------------------------------------------
Status2('busy','Create Filter',3);
fwidx = 2*round((ReconPars.Imfovx/RCOMB.profres)/2);
fwidy = 2*round((ReconPars.Imfovy/RCOMB.profres)/2);
fwidz = 2*round((ReconPars.Imfovz/RCOMB.profres)/2);
F0 = Kaiser_v1b(fwidx,fwidy,fwidz,RCOMB.proffilt,'unsym');
F = zeros(x,y,z);
F(x/2-fwidx/2+1:x/2+fwidx/2,y/2-fwidy/2+1:y/2+fwidy/2,z/2-fwidz/2+1:z/2+fwidz/2) = F0;
Status2('done','Create Filter',3);

%-------------------------------------------
% Create Low Resolution Images
%-------------------------------------------
lowresIms = complex(zeros([x,y,z,rcvrs]),zeros([x,y,z,rcvrs]));
for n = 1:rcvrs
    lowresIms(:,:,:,n) = fftshift(ifftn(ifftshift(kdata(:,:,:,RCOMB.useexp,n).*F)));
    vis = 'Yes';
    if strcmp(vis,'Yes')
        lowresIm = squeeze(abs(lowresIms(:,:,:,n)));
        lowresIm = lowresIm/(max(lowresIm(:)));
        IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = ceil(z/20); IMSTRCT.stop = z; 
        IMSTRCT.rows = 5; IMSTRCT.lvl = [0 1]; IMSTRCT.SLab = 0; IMSTRCT.figno = 5000+n; 
        IMSTRCT.docolor = 0; IMSTRCT.figsize = [];  
        ImageMontage_v2a(lowresIm,IMSTRCT);
    end
end
clear kdata
    
%-------------------------------------------
% Create Low Res SOS Image
%-------------------------------------------
lowressq = complex(zeros(size(lowresIms)),zeros(size(lowresIms)));
for n = 1:rcvrs
    lowressq(:,:,:,n) = lowresIms(:,:,:,n).*conj(lowresIms(:,:,:,n));
end
lowresSOS = sum(lowressq,4);
clear lowressq;

%-------------------------------------------
% Create High-Low Res SOS Image
%-------------------------------------------
hlressq = complex(zeros(size(highresIms)),zeros(size(highresIms)));
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

%-------------------------------------------
% Add
%-------------------------------------------
holdIms(:,:,:,:,rcvrs+1) = Im;

%---------------------------------------------
% Return
%---------------------------------------------
RCOMB.Im = holdIms;

Status2('done','',2);
Status2('done','',3);



