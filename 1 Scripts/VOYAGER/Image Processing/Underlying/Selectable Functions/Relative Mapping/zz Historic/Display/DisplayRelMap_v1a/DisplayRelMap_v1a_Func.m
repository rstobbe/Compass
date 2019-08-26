%===========================================
% 
%===========================================

function [DISP,err] = DisplayRelMap_v1a_Func(DISP,INPUT)

Status2('busy','Display Relative Image Map',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
Im = INPUT.Im;
ISCL = DISP.ISCL;
ICHRS = DISP.ICHRS;
FCHRS = DISP.FCHRS;
PLOT = DISP.PLOT;
clear INPUT;

%----------------------------------------------
% Contrast
%----------------------------------------------
func = str2func([DISP.imscalefunc,'_Func']);  
INPUT.MSTRCT = struct();
INPUT.Image = Im;
[ISCL,err] = func(ISCL,INPUT);
if err.flag
    return
end
clear INPUT;
Image = ISCL.Image;
MSTRCT = ISCL.MSTRCT;

%----------------------------------------------
% FigureChars
%----------------------------------------------
func = str2func([DISP.figcharsfunc,'_Func']);  
INPUT.MSTRCT = MSTRCT;
[FCHRS,err] = func(FCHRS,INPUT);
if err.flag
    return
end
clear INPUT;
MSTRCT = FCHRS.MSTRCT;

%----------------------------------------------
% ImageChars
%----------------------------------------------
func = str2func([DISP.imcharsfunc,'_Func']);  
INPUT.MSTRCT = MSTRCT;
INPUT.Image = Image;
[ICHRS,err] = func(ICHRS,INPUT);
if err.flag
    return
end
clear INPUT;
MSTRCT = ICHRS.MSTRCT;

%----------------------------------------------
% Plot
%----------------------------------------------
func = str2func([DISP.plotfunc,'_Func']);  
INPUT.Image = Image;
INPUT.MSTRCT = MSTRCT;
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
Status2('done','',2);
Status2('done','',3);