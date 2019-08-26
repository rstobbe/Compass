%===========================================
% 
%===========================================

function [DISP,err] = SubPlotMontage_v1a_Func(DISP,INPUT)

Status2('busy','Display Image Montage',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
Im = INPUT.Im;
ICHRS = DISP.ICHRS;
FCHRS = DISP.FCHRS;
CRTE = DISP.CRTE;
DPROPS = [];
if isfield(INPUT,'DPROPS');
    DPROPS = INPUT.DPROPS;
end
if isfield(INPUT,'Name');
    Name = INPUT.Name;
else
    Name = 'poopy pants';
end
clear INPUT;
   
%----------------------------------------------
% ImageChars
%----------------------------------------------
func = str2func([DISP.imcharsfunc,'_Func']);  
INPUT.Image = Im;
INPUT.MSTRCT = struct();
[ICHRS,err] = func(ICHRS,INPUT);
if err.flag
    return
end
clear INPUT;
Im = ICHRS.Image;
ICHRS = rmfield(ICHRS,'Image');
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

%---------------------------------------------
% Plot Montage
%---------------------------------------------
func = str2func([DISP.createfunc,'_Func']);  
INPUT.Image = Im;
INPUT.MSTRCT = MSTRCT;
INPUT.DPROPS = DPROPS;
INPUT.Name = Name;
[CRTE,err] = func(CRTE,INPUT);
if err.flag
    return
end

%---------------------------------------------
% Return
%---------------------------------------------
DISP.ICHRS = ICHRS;
DISP.FCHRS = FCHRS;
DISP.MSTRCT = MSTRCT;
DISP.CRTE = CRTE;


Status2('done','',2);
Status2('done','',3);
