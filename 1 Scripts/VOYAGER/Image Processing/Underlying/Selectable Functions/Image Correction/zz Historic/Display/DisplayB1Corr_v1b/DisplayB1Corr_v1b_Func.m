%===========================================
% 
%===========================================

function [DISP,err] = DisplayB1Corr_v1b_Func(DISP,INPUT)

Status2('busy','Display B1 Correction',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
Im0 = INPUT.Im0;
ImNew = INPUT.ImNew;
MSCL = DISP.MSCL;
ICHRS = DISP.ICHRS;
FCHRS = DISP.FCHRS;
PLOT = DISP.PLOT;
clear INPUT;

%---------------------------------------------
% Image Select
%---------------------------------------------
if strcmp(DISP.type,'New')
    Im = ImNew;
elseif strcmp(DISP.type,'RelChange')
    Im = (ImNew-Im0)./Im0;   
elseif strcmp(DISP.type,'Old')    
    Im = Im0;
end

%----------------------------------------------
% Return Contrast Limits
%----------------------------------------------
func = str2func([DISP.mapscalefunc,'_Func']);  
INPUT.MSTRCT = struct();
INPUT.Image = Im;
[MSCL,err] = func(MSCL,INPUT);
if err.flag
    return
end
clear INPUT;
Im = MSCL.Image;
MSTRCT = MSCL.MSTRCT;

%----------------------------------------------
% ImageChars
%----------------------------------------------
func = str2func([DISP.imcharsfunc,'_Func']);  
INPUT.MSTRCT = MSTRCT;
INPUT.Image = Im;
[ICHRS,err] = func(ICHRS,INPUT);
if err.flag
    return
end
clear INPUT;
Image = ICHRS.Image;
MSTRCT = ICHRS.MSTRCT;

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

