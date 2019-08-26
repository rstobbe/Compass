%====================================================
%  
%====================================================

function [B1MAP,err] = B1MapSingleRcvr_v2c_Func(B1MAP,INPUT)

Status2('busy','Generate B1-Map',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Im = INPUT.Image;
ReconPars = INPUT.ReconPars;
flip = INPUT.flipangle;
LPASS = B1MAP.LPASS;
clear INPUT;

%---------------------------------------------
% Test
%---------------------------------------------
if flip(1) > flip(2)
    dir = 1;
    if flip(1)/flip(2) ~= 2
        err.flag = 1;
        err.msg = 'Flip1 should be 2x Flip2';
        return
    end
else
    dir = 2;
    if flip(2)/flip(1) ~= 2
        err.flag = 1;
        err.msg = 'Flip2 should be 2x Flip1';
        return
    end
end

%---------------------------------------------
% Low Pass Filter
%---------------------------------------------
IMG.ReconPars = ReconPars;
func = str2func([B1MAP.lpassfunc,'_Func']);  
for n = 1:2
    IMG.Im = squeeze(Im(:,:,:,n));
    INPUT.IMG = IMG;
    [LPASS,err] = func(LPASS,INPUT);
    if err.flag
        return
    end
    clear INPUT;
    Im(:,:,:,n) = LPASS.Im;
end

%---------------------------------------------
% Image Absolute Value
%---------------------------------------------
BaseIm = abs(mean(Im,4));
AbsIms = abs(Im);

%---------------------------------------------
% Mask
%---------------------------------------------
mask = BaseIm;
mask(mask < B1MAP.maskval*max(BaseIm(:))) = NaN;
mask(mask >= B1MAP.maskval*max(BaseIm(:))) = 1;

%---------------------------------------------
% Calc
%---------------------------------------------
if dir == 1
    ImRel = (AbsIms(:,:,:,2)./AbsIms(:,:,:,1)).*mask;
else
    ImRel = (AbsIms(:,:,:,1)./AbsIms(:,:,:,2)).*mask;
end

% mask(isnan(mask)) = 0;
% masktot = sum(mask(:))

% INPUT.Image = ImRel;
% INPUT.MSTRCT.type = 'real';
% INPUT.MSTRCT.colour = 'Yes';
% INPUT.MSTRCT.dispwid = [0.3 1.1];
% INPUT.MSTRCT.figno = num2str(100);
% [err] = PlotMontage_v1c(INPUT); 
% title('Relative Image');

ImRel(ImRel<0.5) = NaN;             % noise related error

% INPUT.Image = ImRel;
% INPUT.MSTRCT.type = 'real';
% INPUT.MSTRCT.colour = 'Yes';
% INPUT.MSTRCT.dispwid = [0.5 1.1];
% INPUT.MSTRCT.figno = num2str(101);
% [err] = PlotMontage_v1c(INPUT); 
% title('Relative Image');

Imflip = acos(1./(2*ImRel));
if dir == 1
    B1map = (Imflip*180/pi)/flip(2);
else
    B1map = (Imflip*180/pi)/flip(1);
end

% INPUT.Image = B1map;
% INPUT.MSTRCT.type = 'real';
% INPUT.MSTRCT.colour = 'Yes';
% INPUT.MSTRCT.dispwid = [0 1.5];
% INPUT.MSTRCT.figno = num2str(102);
% [err] = PlotMontage_v1c(INPUT);
% title('B1 Map');

%---------------------------------------------
% Test
%---------------------------------------------
if not(isreal(B1map));
    error();
end

%---------------------------------------------
% Functionality Test
%---------------------------------------------
B1TxDepend = sin(B1map*pi*flip(1)/180)/sin(pi*flip(1)/180);
B1CorIm(:,:,:,1) = AbsIms(:,:,:,1)./B1TxDepend;
B1TxDepend = sin(B1map*pi*flip(2)/180)/sin(pi*flip(2)/180);
B1CorIm(:,:,:,2) = AbsIms(:,:,:,2)./B1TxDepend;

ImRel = (B1CorIm(:,:,:,2)./B1CorIm(:,:,:,1));

INPUT.Image = B1CorIm(:,:,:,1);
INPUT.MSTRCT.type = 'abs';
INPUT.MSTRCT.colour = 'Yes';
%INPUT.MSTRCT.dispwid = [0.3 1.1];
INPUT.MSTRCT.figno = num2str(100);
[err] = PlotMontage_v1c(INPUT); 
title('Relative Image');

%---------------------------------------------
% Return
%---------------------------------------------
B1MAP.Im = B1map;


Status2('done','',2);
Status2('done','',3);
