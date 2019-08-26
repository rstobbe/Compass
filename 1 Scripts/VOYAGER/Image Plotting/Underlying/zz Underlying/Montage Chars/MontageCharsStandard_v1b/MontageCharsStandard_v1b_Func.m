%=========================================================
% 
%=========================================================

function [MCHRS,err] = MontageCharsStandard_v1b_Func(MCHRS,INPUT)

Status2('busy','Return Montage Chars',2);

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
INPUT.orient = 'Axial';
INPUT.rotation = 0;
INPUT.insets = [0,0,0,0,0,0];
INPUT.figno = 'Continue';
INPUT.slclbl = 'Yes';
INPUT.numberslices = 30;
INPUT.Image = Image;
INPUT.MSTRCT = MSTRCT;
[MCHRS,err] = DefaultMontageChars_v1a(INPUT);

Status2('done','',2);
