%====================================================
%  
%====================================================

function [MAP,err] = PairSubMean_v1a_Func(MAP,INPUT)

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
% Base Image
%---------------------------------------------
bIm = mean(Im,4);

%---------------------------------------------
% Mask
%---------------------------------------------
mask = bIm;
mask(mask < MAP.maskval*max(mask(:))) = NaN;
mask(mask >= MAP.maskval*max(mask(:))) = 1;

%---------------------------------------------
% Separate (assume interleave)
%---------------------------------------------
%Im = abs(Im);
sz = size(Im);
tag = (1:2:sz(4));
control = (2:2:sz(4));
tIms = Im(:,:,:,tag);
cIms = Im(:,:,:,control);

dIms = zeros(size(Im));
for n = 1:sz(4)/2
    dIms(:,:,:,n) = tIms(:,:,:,n) - cIms(:,:,:,n);
end

%Map = mean(dIms,4)./mean(Im,4);

avenum = 20;
%Map = dIms(:,:,:,avenum)./tIms(:,:,:,avenum);
Map = dIms(:,:,:,avenum)./mean(Im,4);
%Map = dIms(:,:,:,avenum);

MAP.Im = Map.*mask;

Status2('done','',2);
Status2('done','',3);

