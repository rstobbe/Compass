%=====================================================
%
%=====================================================

function [IMSCL,err] = ImageContrastRelMag_v1c_Func(IMSCL,INPUT)

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
minval = IMSCL.minrelval*maxval0;
maxval = IMSCL.maxrelval*maxval0;

%---------------------------------------------
% MSTRCT
%---------------------------------------------
MSTRCT.dispwid = [minval maxval];
MSTRCT.type = 'abs';
MSTRCT.colour = IMSCL.colour;
MSTRCT.zero = 'black';

%---------------------------------------------
% Return
%---------------------------------------------
IMSCL.Image = Image;
IMSCL.MSTRCT = MSTRCT;

Status2('done','Image Scale',3);