%===========================================
% 
%===========================================

function [DISP,err] = SubPlotMontage_v1b_Func(DISP,INPUT)

Status2('busy','Display Image Montage',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
Im = INPUT.Im;
IMCHRS = DISP.IMCHRS;
CREATE = DISP.CREATE;
Name = INPUT.Name;
ImInfo = INPUT.ImInfo;
clear INPUT;

%---------------------------------------------
% Test Input
%---------------------------------------------
MSTRCT.ImInfo = ImInfo;

%----------------------------------------------
% ImageChars
%----------------------------------------------
func = str2func([DISP.imcharsfunc,'_Func']);  
INPUT.Image = Im;
INPUT.MSTRCT = MSTRCT;
[IMCHRS,err] = func(IMCHRS,INPUT);
if err.flag
    return
end
clear INPUT;
Im = IMCHRS.Image;
MSTRCT = IMCHRS.MSTRCT;

%----------------------------------------------
% Plot
%----------------------------------------------
func = str2func([DISP.createfunc,'_Func']);  
INPUT.Image = Im;
INPUT.MSTRCT = MSTRCT;
INPUT.Name = Name;
[CREATE,err] = func(CREATE,INPUT);
if err.flag
    return
end
if isfield(CREATE,'Im')
    DISP.Im = CREATE.Im;
    DISP.MSTRCT = CREATE.MSTRCT;
    DISP.IMDISP = CREATE.IMDISP;
    DISP.CompassDisplay = CREATE.CompassDisplay;
end

Status2('done','',2);
Status2('done','',3);
