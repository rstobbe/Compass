%=========================================================
% 
%=========================================================

function [PLOT,err] = PlotMontage_v1g_Func(PLOT,INPUT)

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
CREATE = INPUT.CREATE;
clear INPUT;

%---------------------------------------------
% Test Input
%---------------------------------------------
if iscell(IMG)
    if length(IMG) == 2
        Im = cat(4,IMG{1}.Im(:,:,:,1,1,1),IMG{2}.Im(:,:,:,1,1,1));
        ImInfo = IMG{1}.IMDISP.ImInfo;
    else
        IMG = IMG{1};
        Im = IMG.Im;
        ImInfo = IMG.IMDISP.ImInfo;
    end
else
    Im = IMG.Im;
    ImInfo = IMG.IMDISP.ImInfo;
end
MSTRCT.ImInfo = ImInfo;

%----------------------------------------------
% ImageChars
%----------------------------------------------
func = str2func([PLOT.imcharsfunc,'_Func']);  
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
if isfield(CREATE,'Im')
    PLOT.Im = CREATE.Im;
    PLOT.MSTRCT = CREATE.MSTRCT;
    PLOT.IMDISP = CREATE.IMDISP;
    PLOT.CompassDisplay = CREATE.CompassDisplay;
end
if isfield(CREATE,'Figure')
    PLOT.Figure = CREATE.Figure;
end

%----------------------------------------------
% Change Matlab Path
%----------------------------------------------
%cd(IMG.path);
if isfield(IMG,'name')
    PLOT.name = IMG.name;
    if strfind(PLOT.name,'.mat')
        PLOT.name = PLOT.name(1:end-4);
    end
    if strfind(PLOT.name,'.nii')
        PLOT.name = PLOT.name(1:end-4);
    end  
    if strfind(PLOT.name,'.hdr')
        PLOT.name = PLOT.name(1:end-4);
    end  
    ind = strfind(PLOT.name,'IMG_');
    if ind
        PLOT.name = PLOT.name(ind+4:end);
    end
else
    PLOT.name = '';
end
if isfield(PLOT,'Figure')
    PLOT.Figure.hFig.Name = ['PLOT_',PLOT.name];
    PLOT.Figure.Name = ['PLOT_',PLOT.name];
end

%---------------------------------------------
% Get Input
%---------------------------------------------
if isfield(IMG,'PanelOutput')
    PLOT.PanelOutput = IMG.PanelOutput;
else 
    PLOT.PanelOutput = [];
end
    
Status('done','');
Status2('done','',2);
Status2('done','',3);
