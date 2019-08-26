%=========================================================
% 
%=========================================================

function [MCHRS,err] = MontageCharsStandard_v1a_Func(MCHRS,INPUT)

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
% Return Standard
%---------------------------------------------
MCHRS.orient = 'Axial';
MCHRS.rotation = 0;
MCHRS.slices = [];
MCHRS.insets = '0,0,0,0,0,0';

%---------------------------------------------
% Determine Slices (aim for 40)
%---------------------------------------------
sz = size(Image);
if length(sz) == 2
    step = 1;
    stop = 1;
else
    step = round(sz(3)/40);
    stop = sz(3);
end
if step == 0
    step = 1;
end

%---------------------------------------------
% MSTRCT
%---------------------------------------------
MSTRCT.start = step;
MSTRCT.stop = stop;
MSTRCT.step = step;
%MSTRCT.ncolumns = na;               % use plotting default

%----------------------------------------------
% Standard Options
%----------------------------------------------
MSTRCT.imsize = [];
MSTRCT.figno = 'Continue';
MSTRCT.slclbl = 'Yes';

%---------------------------------------------
% Return
%---------------------------------------------
MCHRS.MSTRCT = MSTRCT;
MCHRS.Image = Image;

Status2('done','',3);
