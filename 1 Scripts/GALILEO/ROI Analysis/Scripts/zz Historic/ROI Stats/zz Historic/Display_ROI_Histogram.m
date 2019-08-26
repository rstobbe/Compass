%============================================
% ROI Histograms
%============================================

function Display_ROI_Histogram

[ROI_Arr] = Extract_ROI_Array(1,1);

MaxV = max(ROI_Arr);
figure(2)
hist(ROI_Arr,(0:MaxV));


