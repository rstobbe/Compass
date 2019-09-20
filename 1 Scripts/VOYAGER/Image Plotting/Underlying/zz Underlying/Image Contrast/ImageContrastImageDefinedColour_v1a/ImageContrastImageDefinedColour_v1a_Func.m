%=====================================================
%
%=====================================================

function [IMSCL,err] = ImageContrastImageDefinedColour_v1a_Func(IMSCL,INPUT)

Status2('busy','Image Contrast',3);

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
MSTRCT.useimagecolour = 'Yes';
MSTRCT.dispwid = [];
MSTRCT.type = [];

%---------------------------------------------
% Return
%---------------------------------------------
IMSCL.Image = Image;
IMSCL.MSTRCT = MSTRCT;

Status2('done','Image Contrast',3);