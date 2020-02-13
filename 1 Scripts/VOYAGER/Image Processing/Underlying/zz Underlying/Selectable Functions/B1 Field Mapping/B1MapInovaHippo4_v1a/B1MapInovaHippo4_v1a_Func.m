%====================================================
%  
%====================================================

function [B1MAP,err] = B1MapInovaHippo4_v1a_Func(B1MAP,INPUT)

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

% INPUT.Image = BaseIm;
% INPUT.MSTRCT.type = 'real';
% INPUT.MSTRCT.colour = 'Yes';
% INPUT.MSTRCT.dispwid = [0 max(BaseIm(:))];
% INPUT.MSTRCT.figno = 100;
% [err] = PlotMontage_v1c(INPUT); 
% title('BaseIm');
% 
% INPUT.Image = BaseIm.*mask;
% INPUT.MSTRCT.type = 'real';
% INPUT.MSTRCT.colour = 'Yes';
% INPUT.MSTRCT.dispwid = [0 max(BaseIm(:))];
% INPUT.MSTRCT.figno = 101;
% [err] = PlotMontage_v1c(INPUT); 
% title('BaseIm');

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
% INPUT.MSTRCT.figno = 100;
% [err] = PlotMontage_v1c(INPUT); 
% title('Relative Image');

ImRel(ImRel<0.5) = NaN;             % noise related error

% INPUT.Image = ImRel;
% INPUT.MSTRCT.type = 'real';
% INPUT.MSTRCT.colour = 'Yes';
% INPUT.MSTRCT.dispwid = [0.5 1.1];
% INPUT.MSTRCT.figno = 101;
% [~,err] = PlotMontage_v1c(INPUT); 
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
if not(isreal(B1map))
    error();
end

%---------------------------------------------
% Scale (for pulse power calibration)
%---------------------------------------------
B1map = B1map/1.033;                            % Feb - 2020  (from testing in saline phantom)  ** for Hippo4 protocol!

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',B1MAP.method,'Output'};
B1MAP.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Return
%---------------------------------------------
B1MAP.B1Map = B1map;

Status2('done','',2);
Status2('done','',3);
