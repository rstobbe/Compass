%=========================================================
% 
%=========================================================

function [MCHRS,err] = MontageCharsImArrStandard_v1a_Func(MCHRS,INPUT)

Status2('busy','Return Montage Chars',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Image = INPUT.Image;
MSTRCT = INPUT.MSTRCT;
clear INPUT;

%---------------------------------------------
% Select Image from Image Array
%---------------------------------------------
sz = size(Image);
if length(MCHRS.imnum) > 1
    if MCHRS.imnum(1) > sz(4) || MCHRS.imnum(2) > sz(5)
        err.flag = 1;
        err.msg = 'ImageNum beyond length of Image Array';
        return
    end
    Image = Image(:,:,:,MCHRS.imnum(1),MCHRS.imnum(2));
else
    if MCHRS.imnum(1) > sz(4)
        err.flag = 1;
        err.msg = 'ImageNum beyond length of Image Array';
        return
    end
    Image = Image(:,:,:,MCHRS.imnum);
end
    
%---------------------------------------------
% Return Standard
%---------------------------------------------
MCHRS.orient = 'Axial';
MCHRS.rotation = 0;
MCHRS.slices = [];
MCHRS.insets = '0,0,0,0,0,0';

%---------------------------------------------
% Determine Slices (aim for 64)
%---------------------------------------------
sz = size(Image);
step = round(sz(3)/64);
if step == 0
    step = 1;
end

%---------------------------------------------
% MSTRCT
%---------------------------------------------
MSTRCT.start = step;
MSTRCT.stop = sz(3);
MSTRCT.step = step;

%---------------------------------------------
% Return
%---------------------------------------------
MCHRS.MSTRCT = MSTRCT;
MCHRS.Image = Image;

Status2('done','',3);
