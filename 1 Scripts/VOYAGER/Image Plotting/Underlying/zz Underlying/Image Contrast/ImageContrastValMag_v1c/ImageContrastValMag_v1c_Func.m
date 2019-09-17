%=====================================================
%
%=====================================================

function [IMSCL,err] = ImageContrastValMag_v1c_Func(IMSCL,INPUT)

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
% MSTRCT
%---------------------------------------------
MSTRCT.dispwid = [IMSCL.minval IMSCL.maxval];
MSTRCT.type = 'abs';
MSTRCT.colour = 'No';
MSTRCT.zero = 'black';

%---------------------------------------------
% Return
%---------------------------------------------
IMSCL.Image = Image;
IMSCL.MSTRCT = MSTRCT;

Status2('done','Image Scale',3);