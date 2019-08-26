%=========================================================
% 
%=========================================================

function [FCHRS,err] = FigureCharsHShimHeadV_v1a_Func(FCHRS,INPUT)

Status2('busy','Montage Figure Chars',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
MSTRCT = INPUT.MSTRCT;
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
MSTRCT.ncolumns = 7;
MSTRCT.imsize = '900,1100';
MSTRCT.figno = 'Continue';
MSTRCT.slclbl = 'Yes';

FCHRS.MSTRCT = MSTRCT;

Status2('done','',3);