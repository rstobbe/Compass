%====================================================
%  
%====================================================

function [B1MAP,err] = B1Map2AngleLPF_v2b_Func(B1MAP,INPUT)

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
AbsIms = abs(Im);

%---------------------------------------------
% Mask
%---------------------------------------------
mask = mean(AbsIms,4);
mask(mask < B1MAP.maskval*max(mask(:))) = NaN;
mask(mask >= B1MAP.maskval*max(mask(:))) = 1;
AbsIms(:,:,:,1) = AbsIms(:,:,:,1).*mask;
AbsIms(:,:,:,2) = AbsIms(:,:,:,2).*mask;

%---------------------------------------------
% Calc
%---------------------------------------------
if dir == 1
    ImRel = AbsIms(:,:,:,2)./AbsIms(:,:,:,1);
    test = min(ImRel(:));
    if test < 0.5
        err.flag = 1;
        err.msg = 'Capturing too much noise - fix mask';
        return
    end
    Imflip = acos(1./(2*ImRel));
    B1map = (Imflip*180/pi)/flip(2);
else
    ImRel = AbsIms(:,:,:,1)./AbsIms(:,:,:,2);
    test = min(ImRel(:));
    if test < 0.5
        err.flag = 1;
        err.msg = 'Capturing too much noise - fix mask';
        return
    end
    Imflip = acos(1./(2*ImRel));
    B1map = (Imflip*180/pi)/flip(1);
end

%---------------------------------------------
% Test
%---------------------------------------------
% INPUT.Image = ImRel;
% INPUT.MSTRCT.type = 'real';
% INPUT.MSTRCT.colour = 'Yes';
% INPUT.MSTRCT.dispwid = [0.5 0.75];
% INPUT.MSTRCT.figno = '100';
% [err] = PlotMontage_v1a(INPUT);

%---------------------------------------------
% Test
%---------------------------------------------
if not(isreal(B1map));
    error();
end

%---------------------------------------------
% Return
%---------------------------------------------
B1MAP.Im = B1map;


Status2('done','',2);
Status2('done','',3);

