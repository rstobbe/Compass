%=====================================================
%
%=====================================================

function [IMSCL,err] = ImageContrastPhaseMap_v1a_Func(IMSCL,INPUT)

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
minval = -pi;
maxval = pi;

%---------------------------------------------
% MSTRCT
%---------------------------------------------
MSTRCT.dispwid = [minval maxval];
MSTRCT.type = 'phase';

%---------------------------------------------
% Return
%---------------------------------------------
IMSCL.Image = Image;
IMSCL.MSTRCT = MSTRCT;

Status2('done','',3);


