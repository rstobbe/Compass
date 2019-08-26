%=========================================================
% 
%=========================================================

function [FCHRS,err] = FigureCharsEdit_v1b_Func(FCHRS,INPUT)

Status2('busy','Montage Figure Chars',3);

global FIGOBJS

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Create Structure
%---------------------------------------------
MSTRCT = INPUT.MSTRCT;
MSTRCT.ncolumns = FCHRS.ncolumns;
MSTRCT.imsize = FCHRS.imsize;
MSTRCT.slclbl = FCHRS.slclbl;
clear INPUT;

%---------------------------------------------
% Plot Location
%---------------------------------------------
if strcmp(FCHRS.externalwindow,'No')
    MSTRCT.fighand = FIGOBJS.IM.ImAxes;
else
    MSTRCT.fighand = FCHRS.figno;
end

%---------------------------------------------
% Return
%---------------------------------------------
FCHRS.MSTRCT = MSTRCT;

Status2('done','',2);
Status2('done','',3);