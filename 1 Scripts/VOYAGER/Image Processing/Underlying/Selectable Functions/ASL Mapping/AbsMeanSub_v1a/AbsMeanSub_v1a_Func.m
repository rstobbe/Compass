%====================================================
%  
%====================================================

function [MAP,err] = AbsMeanSub_v1a_Func(MAP,INPUT)

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
Im = abs(Im);
sz = size(Im);
tag = (1:2:sz(4));
control = (2:2:sz(4));
tIms = Im(:,:,:,tag);
cIms = Im(:,:,:,control);
tIm = mean(tIms,4);
cIm = mean(cIms,4);
%Map = (tIm - cIm);
Map = (tIm - cIm)./((tIm+cIm)/2);

MAP.Im = Map.*mask;

Status2('done','',2);
Status2('done','',3);

