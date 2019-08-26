%=========================================================
% 
%=========================================================

function [ROIPLOT,err] = PlotRoiStandard_v1a_Func(ROIPLOT,INPUT)

Status2('busy','Plot Montage',3);

err.flag = 0;
err.msg = '';

%----------------------------------------------
% Get input
%----------------------------------------------
Image = INPUT.Image;
MSTRCT = INPUT.MSTRCT;
PLOT = INPUT.PLOT;
ROIarr = INPUT.ROIarr;
clear INPUT

%---------------------------------------------
% Test ROI
%---------------------------------------------
sz = size(Image);
for n = 1:length(ROIarr)
    ROI = ROIarr(n);
    if sz(1) ~= ROI.roiimsize(1) || sz(2) ~= ROI.roiimsize(2) || sz(3) ~= ROI.roiimsize(3)
        err.flag = 1;
        err.msg = 'ROI and Image not compatible';
        return
    end
end
clr = 'r';
slice = MSTRCT.start;

for n = 1:length(ROIarr)
    ROIarr(n).OutsideDrawROI(slice,PLOT.handles.ahand,clr); 
end

Status2('done','',3);
