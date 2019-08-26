%=========================================================
% 
%=========================================================

function [FCHRS,err] = FigureCharsShimNaV_v1a_Func(FCHRS,INPUT)

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
MSTRCT.ncolumns = 8;
MSTRCT.imsize = '900,900';
MSTRCT.figno = 'Continue';
MSTRCT.slclbl = 'Yes';

FCHRS.MSTRCT = MSTRCT;

Status2('done','',3);