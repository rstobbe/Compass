%=====================================================
%
%=====================================================

function [RCOMB,err] = RcvComb_Super_v1e_Func(RCOMB,INPUT)

Status2('busy','Combine Receivers',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
highresIms = INPUT.Im;
ReconPars = INPUT.ReconPars;
clear INPUT;

%---------------------------------------------
% Test
%---------------------------------------------
if length(size(highresIms))~=5
    err.flag = 1;
    err.msg = 'Do not have 5D data';
    return
end
[x,y,z,nexp,rcvrs] = size(highresIms);            % x,y,z must be even...
if nexp ~= 1
    err.flag = 1;
    err.msg = 'Multi-experiment not supported';
    return
end
highresIms = squeeze(highresIms);

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

%---------------------------------------------
% Create Low Resolution Images
%---------------------------------------------
lowresIms = complex(zeros(size(highresIms)),zeros(size(highresIms)));
for n = 1:rcvrs
    Status2('busy',['Create Low-Res Images (rcvr',num2str(n),')'],3);
    lowresIms(:,:,:,n) = fftshift(ifftn(ifftshift(fftshift(fftn(ifftshift(highresIms(:,:,:,n)))).*F)));
end

%-------------------------------------------
% Create Coil Sensitiviy Estimate
%-------------------------------------------
lowresSOS = sqrt(sum((lowresIms.*conj(lowresIms)),4));
relcoilsensitivity = complex(zeros(size(highresIms)),zeros(size(highresIms)));
for n = 1:rcvrs
    relcoilsensitivity(:,:,:,n) = lowresIms(:,:,:,n)./lowresSOS;
end
clear lowresSOS
clear lowresIms

%-------------------------------------------
% Plot Coil Sensitivity
%-------------------------------------------
vis = 'Yes';
if strcmp(vis,'Yes')
    IMSTRCT.type = 'abs'; IMSTRCT.start = 1; IMSTRCT.step = ceil(z/20); IMSTRCT.stop = z; 
    IMSTRCT.rows = 5; IMSTRCT.lvl = [0 max(abs(relcoilsensitivity(:)))]; IMSTRCT.SLab = 0; 
    IMSTRCT.docolor = 0; IMSTRCT.figsize = [];  
    for n = 1:rcvrs
        IMSTRCT.figno = 5000+n; 
        ImageMontage_v2a(relcoilsensitivity(:,:,:,n),IMSTRCT);
    end
end

%-------------------------------------------
% Return
%-------------------------------------------
RCOMB.Im = (sum((highresIms.*conj(relcoilsensitivity)),4))./(sum((relcoilsensitivity.*conj(relcoilsensitivity)),4));

Status2('done','',2);
Status2('done','',3);








