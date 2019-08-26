%=========================================================
% 
%=========================================================

function [FCHRS,err] = FigureCharsEdit_v1a_Func(FCHRS,INPUT)

Status2('busy','Montage Figure Chars',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
MSTRCT = INPUT.MSTRCT;
MSTRCT.ncolumns = FCHRS.ncolumns;
MSTRCT.imsize = FCHRS.imsize;
MSTRCT.figno = FCHRS.figno;
MSTRCT.slclbl = FCHRS.slclbl;
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
FCHRS.MSTRCT = MSTRCT;

Status2('done','',2);
Status2('done','',3);