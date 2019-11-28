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
ROIarr = INPUT.ROIarr;
clear INPUT

%---------------------------------------------
% Test ROI
%---------------------------------------------
% sz = size(Image);
% for n = 1:length(ROIarr)
%     ROI = ROIarr(n);
%     if sz(1) ~= ROI.roiimsize(1) || sz(2) ~= ROI.roiimsize(2) || sz(3) ~= ROI.roiimsize(3)
%         err.flag = 1;
%         err.msg = 'ROI and Image not compatible';
%         return
%     end
% end

%---------------------------------------------
% Plot
%---------------------------------------------
clr = 'rbgcm';
for n = 1:length(ROIarr)
    if strcmp(ROIarr(n).drawroiorient,'Coronal')
        SliceArray0 = MSTRCT.SliceArray;
        SliceArray1 = SliceArray0(SliceArray0 ~= 0);
        SliceArray1 = flip(SliceArray1);
        SliceArray = zeros(size(SliceArray0));
        numzeros = length(SliceArray0) - length(SliceArray1);
        SliceArray(1:end-numzeros) = SliceArray1;
    elseif strcmp(ROIarr(n).drawroiorient,'Sagittal')
    elseif strcmp(ROIarr(n).drawroiorient,'Axial') 
        SliceArray = MSTRCT.SliceArray;
    end
    for m = 1:length(SliceArray)
        ROIarr(n).OutsideOffsetsDrawROI(MSTRCT.Vadd(m),MSTRCT.Hadd(m),SliceArray(m),MSTRCT.ahand,clr(n));
    end
end

Status2('done','',3);
