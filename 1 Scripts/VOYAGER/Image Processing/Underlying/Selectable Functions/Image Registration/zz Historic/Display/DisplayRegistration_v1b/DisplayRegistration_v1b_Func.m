%===========================================
% 
%===========================================

function [DISP,err] = DisplayRegistration_v1b_Func(DISP,INPUT)

Status2('busy','Display Registration',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
Im1 = INPUT.Im1;
Im2 = INPUT.Im2;
IM1CONT = DISP.IM1CONT;
IM2CONT = DISP.IM2CONT;
ICHRS = DISP.ICHRS;
FCHRS = DISP.FCHRS;
PLOT = DISP.PLOT;
clear INPUT;

%----------------------------------------------
% Return Contrast Limits 1
%----------------------------------------------
func = str2func([DISP.contrast1func,'_Func']);  
INPUT.MSTRCT = struct();
INPUT.Image = Im1;
[IM1CONT,err] = func(IM1CONT,INPUT);
if err.flag
    return
end
clear INPUT;
Im1 = IM1CONT.Image;
MSTRCT1 = IM1CONT.MSTRCT;

%----------------------------------------------
% Return Contrast Limits 2
%----------------------------------------------
func = str2func([DISP.contrast2func,'_Func']);  
INPUT.MSTRCT = struct();
INPUT.Image = Im2;
[IM2CONT,err] = func(IM2CONT,INPUT);
if err.flag
    return
end
clear INPUT;
Im2 = IM2CONT.Image;
MSTRCT2 = IM2CONT.MSTRCT;

%----------------------------------------------
% Combine
%----------------------------------------------
[x,y,z] = size(Im1);
Image = zeros([x,y,z,2]);
Image(:,:,:,1) = Im1;
Image(:,:,:,2) = Im2;
MSTRCT = MSTRCT1;
MSTRCT.dispwid1 = MSTRCT1.dispwid;
MSTRCT.dispwid2 = MSTRCT2.dispwid;
MSTRCT.type2 = MSTRCT2.type;

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
