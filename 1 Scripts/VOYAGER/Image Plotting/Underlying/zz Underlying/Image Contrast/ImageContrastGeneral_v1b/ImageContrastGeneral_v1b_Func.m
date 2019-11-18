%=====================================================
%
%=====================================================

function [IMSCL,err] = ImageContrastGeneral_v1b_Func(IMSCL,INPUT)

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
inds = strfind(IMSCL.scale,',');
minval = str2double(IMSCL.scale(1:inds(1)-1));
maxval = str2double(IMSCL.scale(inds(1)+1:length(IMSCL.scale)));

%---------------------------------------------
% MSTRCT
%---------------------------------------------
MSTRCT.dispwid = [minval maxval];
MSTRCT.type = IMSCL.type;
MSTRCT.colour = IMSCL.colour;
MSTRCT.zero = 'black';

%---------------------------------------------
% Return
%---------------------------------------------
IMSCL.Image = Image;
IMSCL.MSTRCT = MSTRCT;

Status2('done','',3);