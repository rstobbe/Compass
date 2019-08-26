%====================================================
%  
%====================================================

function [B0MAP,err] = B0map2te_v1a_Func(B0MAP,INPUT)

Status('busy','Generate B0map');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG;
clear INPUT;

%---------------------------------------------
% Mask
%---------------------------------------------
mask = abs(IMG{1}.Im);
mask(mask < B0MAP.MV) = -1000;
mask(mask >= B0MAP.MV) = 0;

%---------------------------------------------
% Process
%---------------------------------------------
phIm1 = angle(IMG{1}.Im);
phIm2 = angle(IMG{2}.Im);
dphIm = phIm2 - phIm1;

dphIm(dphIm > pi) = dphIm(dphIm > pi) - 2*pi;
dphIm(dphIm < -pi) = dphIm(dphIm < -pi) + 2*pi;

if strcmp(B0MAP.Output,'PhaseDif')
    B0MAP.Im = dphIm + mask;
elseif strcmp(B0MAP.Output,'Hz')
    fMap = 1000*(dphIm/(2*pi))/B0MAP.TEdif;
    B0MAP.Im = fMap + mask;
elseif strcmp(B0MAP.Output,'Phase1')
    B0MAP.Im = phIm1 + mask;
elseif strcmp(B0MAP.Output,'Phase2')
    B0MAP.Im = phIm2 + mask;
end

%---------------------------------------------
% Return
%---------------------------------------------
Status('done','');
Status2('done','',2);
Status2('done','',3);

