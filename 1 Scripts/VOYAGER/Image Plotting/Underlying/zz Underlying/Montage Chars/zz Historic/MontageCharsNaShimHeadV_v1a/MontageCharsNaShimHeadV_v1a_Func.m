%=========================================================
% 
%=========================================================

function [MCHRS,err] = MontageCharsNaShimHeadV_v1a_Func(MCHRS,INPUT)

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
MSTRCT.orient = 'Axial';
MSTRCT.rotation = 0;
MSTRCT.slices = [];
MSTRCT.insets = '10,10,50,50,0,0';

%---------------------------------------------
% MSTRCT
%---------------------------------------------
MSTRCT.start = 12;
MSTRCT.stop = 67;
MSTRCT.step = 1;

%---------------------------------------------
% Return
%---------------------------------------------
MCHRS.MSTRCT = MSTRCT;
MCHRS.Image = Image;

Status2('done','',3);
