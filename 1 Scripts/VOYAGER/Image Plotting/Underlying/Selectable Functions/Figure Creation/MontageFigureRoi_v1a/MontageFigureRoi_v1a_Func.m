%=========================================================
% 
%=========================================================

function [MONT,err] = MontageFigureRoi_v1a_Func(MONT,INPUT)

Status2('busy','Create Montage Figure With ROI',2);
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
ROILOAD = MONT.ROILOAD;
ROIPLOT = MONT.ROIPLOT;
clear INPUT

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
% Roi Load
%----------------------------------------------
for n = 1:length(ROILOAD.Files)
	ROI = [];
    load(ROILOAD.Files{n}.loc)
    if isempty(ROI)
        err.flag = 1;
        err.msg = 'File selected does not contain an ROI';
        return
    end
    ROIarr(n) = ROI;
end

%----------------------------------------------
% Plot
%----------------------------------------------
func = str2func([MONT.roiplotfunc,'_Func']);  
INPUT.Image = Image;
INPUT.MSTRCT = MSTRCT;
INPUT.PLOT = PLOT;
INPUT.ROIarr = ROIarr;
[ROIPLOT,err] = func(ROIPLOT,INPUT);
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
