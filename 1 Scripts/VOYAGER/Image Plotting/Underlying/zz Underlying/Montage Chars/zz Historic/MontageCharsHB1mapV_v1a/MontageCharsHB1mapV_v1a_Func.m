%=========================================================
% 
%=========================================================

function [MCHRS,err] = MontageCharsB1mapV_v1a_Func(MCHRS,INPUT)

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
MCHRS.insets = '0,10,0,0,0,0';

%---------------------------------------------
% MSTRCT
%---------------------------------------------
MSTRCT.start = 1;
MSTRCT.stop = 8;
MSTRCT.step = 1;

%---------------------------------------------
% Return
%---------------------------------------------
MCHRS.MSTRCT = MSTRCT;
MCHRS.Image = Image;

Status2('done','',3);
