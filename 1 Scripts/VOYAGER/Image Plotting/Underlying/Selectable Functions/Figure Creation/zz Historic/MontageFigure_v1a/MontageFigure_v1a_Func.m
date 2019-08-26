%=========================================================
% 
%=========================================================

function [MONT,err] = MontageFigure_v1a_Func(MONT,INPUT)

Status2('busy','Create Montage Figure',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%----------------------------------------------
% Get input
%----------------------------------------------
Image = INPUT.Image;
Name = INPUT.Name;
MSTRCT = INPUT.MSTRCT;
IMSCL = MONT.IMSCL;
PLOT = MONT.PLOT;
clear INPUT

%----------------------------------------------
% Test (use 2nd image if from array)
%----------------------------------------------
sz = size(Image);
if length(sz) > 3
    Image = Image(:,:,:,2,1,1,1);
end

%----------------------------------------------
% Scale
%----------------------------------------------
func = str2func([MONT.imscalefunc,'_Func']);  
INPUT.Image = Image;
INPUT.MSTRCT = MSTRCT;
[IMSCL,err] = func(IMSCL,INPUT);
if err.flag
    return
end
clear INPUT;
Image = IMSCL.Image;
MSTRCT = IMSCL.MSTRCT;

%----------------------------------------------
% Plot
%----------------------------------------------
func = str2func([MONT.plotfunc,'_Func']);  
INPUT.Image = Image;
INPUT.MSTRCT = MSTRCT;
INPUT.Name = Name;
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end
clear INPUT;

%----------------------------------------------
% Return
%----------------------------------------------
if isfield(PLOT,'Im');
    MONT.Im = PLOT.Im;
    MONT.MSTRCT = PLOT.MSTRCT;
    MONT.IMDISP = PLOT.IMDISP;
    MONT.CompassDisplay = PLOT.CompassDisplay;
end

Status2('done','',2);
Status2('done','',3);
