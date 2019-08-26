%=========================================================
% 
%=========================================================

function [TST,err] = StabilityCheck_v1a_Func(TST,INPUT)

Status2('busy','Test Image Stability',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Im = INPUT.Image;
Mask = INPUT.Mask;
ReconPars = INPUT.ReconPars;
BaseIm = INPUT.BaseIm;
ExpPars = INPUT.ExpPars;
clear INPUT;

%---------------------------------------------
% Select Subset
%---------------------------------------------
sz = size(Im);
Im = squeeze(Im(:,:,TST.slice,:));
BaseIm = BaseIm(:,:,TST.slice);
BaseIm = repmat(BaseIm,[1 1 sz(4)]);
Mask = Mask(:,:,TST.slice);
Mask = repmat(Mask,[1 1 sz(4)]);

%---------------------------------------------
% Mask Image
%---------------------------------------------
Im = Im.*Mask; 

%---------------------------------------------
% Sort Type
%---------------------------------------------
if strcmp(TST.type,'Abs')
    Im = abs(Im);
elseif strcmp(TST.type,'Phase')
    test = isreal(Im);
    if test == 1
        err.flag = 1;
        err.msg = 'Input Image Not Complex';
        return
    end
    Im = angle(Im);
elseif strcmp(TST.type,'Real')
    Im = real(Im);    
elseif strcmp(TST.type,'Imag')
    Im = imag(Im);
end

%---------------------------------------------
% Find Mean
%---------------------------------------------
MeanIm = mean(Im,3);
sz = size(Im);
ImDif = zeros(sz);
for n = 1:sz(3)
    if strcmp(TST.type,'Phase')
        ImDif(:,:,n) = (180/pi)*(Im(:,:,n) - MeanIm);
    else
        ImDif(:,:,n) = 100*(Im(:,:,n) - MeanIm) ./ MeanIm;
    end
end

%---------------------------------------------
% Return
%---------------------------------------------
TST.Im = ImDif;
TST.BaseIm = BaseIm;
TST.Mask = Mask;


Status('done','');
Status2('done','',2);
Status2('done','',3);
