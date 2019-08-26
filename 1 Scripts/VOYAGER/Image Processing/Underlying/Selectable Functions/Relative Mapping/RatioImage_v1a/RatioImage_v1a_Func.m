%====================================================
%  
%====================================================

function [RATIO,err] = RatioImage_v1a_Func(RATIO,INPUT)

Status2('busy','Ratio Image',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Im = INPUT.Image;
clear INPUT;

%---------------------------------------------
% Type
%---------------------------------------------
if strcmp(RATIO.type,'abs')
    Im = abs(Im);
end

%---------------------------------------------
% Image
%---------------------------------------------
if strcmp(RATIO.dir,'1/2')
    mask = Im(:,:,:,2);
    mask(mask < RATIO.maskval*max(mask(:))) = NaN;
    mask(mask >= RATIO.maskval*max(mask(:))) = 1;
    Map = Im(:,:,:,1)./Im(:,:,:,2);
    %Map = (Im(:,:,:,1)-Im(:,:,:,2))./mean(Im,4);
   % Map = Im(:,:,:,1).*Im(:,:,:,2);
else
    mask = Im(:,:,:,1);
    mask(mask < RATIO.maskval*max(mask(:))) = NaN;
    mask(mask >= RATIO.maskval*max(mask(:))) = 1;
    Map = Im(:,:,:,2)./Im(:,:,:,1);
end
    
RATIO.Im = Map.*mask;

Status2('done','',2);
Status2('done','',3);

