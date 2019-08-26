%=====================================================
%
%=====================================================

function [IMSCL,err] = ImageContrastRelSelect_v1a_Func(IMSCL,INPUT)

Status2('busy','Image Scale',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
Image = INPUT.Image;
MSTRCT = INPUT.MSTRCT;
clear INPUT;

%---------------------------------------------
% Scale
%---------------------------------------------
maxval0 = max(abs(Image(:)));
if strcmp(IMSCL.type,'abs')
    minval = 0;
else
    minval = -IMSCL.maxrelval;
end
maxval = IMSCL.maxrelval;
Image = Image/maxval0;

%---------------------------------------------
% MSTRCT
%---------------------------------------------
MSTRCT.dispwid = [minval maxval];
MSTRCT.type = IMSCL.type;

%---------------------------------------------
% Return
%---------------------------------------------
IMSCL.Image = Image;
IMSCL.MSTRCT = MSTRCT;

