%=========================================================
% 
%=========================================================

function [PLOT,err] = PlotMontage_v1e_Func(PLOT,INPUT)

Status('busy','Plot Montage');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG;
IMCHRS = INPUT.IMCHRS;
FCHRS = INPUT.FCHRS;
CREATE = INPUT.CREATE;
clear INPUT;

%---------------------------------------------
% Test Input
%---------------------------------------------
if iscell(IMG)
    if length(IMG) > 1
        Im = cat(4,IMG{1}.Im,IMG{2}.Im);
        IMG = IMG{2};
    else
        IMG = IMG{1};
        Im = IMG.Im;
    end
else
    Im = IMG.Im;
end

%----------------------------------------------
% ImageChars
%----------------------------------------------
func = str2func([PLOT.imcharsfunc,'_Func']);  
INPUT.Image = Im;
INPUT.MSTRCT = struct();
[IMCHRS,err] = func(IMCHRS,INPUT);
if err.flag
    return
end
clear INPUT;
Im = IMCHRS.Image;
MSTRCT = IMCHRS.MSTRCT;

%----------------------------------------------
% FigureChars
%----------------------------------------------
func = str2func([PLOT.figcharsfunc,'_Func']);  
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
func = str2func([PLOT.createfunc,'_Func']);  
INPUT.Image = Im;
INPUT.MSTRCT = MSTRCT;
if isfield(IMG,'name')
    INPUT.Name = IMG.name;
else
    INPUT.Name = '';
end
[CREATE,err] = func(CREATE,INPUT);
if err.flag
    return
end

%----------------------------------------------
% Change Matlab Path
%----------------------------------------------
cd(IMG.path);

%---------------------------------------------
% Get Input
%---------------------------------------------
if isfield(IMG,'PanelOutput');
    PLOT.PanelOutput = IMG.PanelOutput;
else 
    PLOT.PanelOutput = [];
end
    
Status('done','');
Status2('done','',2);
Status2('done','',3);
