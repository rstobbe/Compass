%=========================================================
% 
%=========================================================

function [FIT,err] = RoiThroughDimension_v1a_Func(FIT,INPUT)

Status2('busy','Roi Through Dimension',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
ROI = INPUT.ROI;
IMAGEANLZ = INPUT.IMAGEANLZ;
clear INPUT

%---------------------------------------------
% Get Image
%---------------------------------------------
for n = 1:39
    IMAGEANLZ.SetDim4(n);
    ROI_ArrCplx(n) = abs(mean(ROI.GetComplexROIDataArray(IMAGEANLZ)));
    ROI_ArrAbs(n) = mean(abs(ROI.GetComplexROIDataArray(IMAGEANLZ)));
end

figure(235); hold on;
plot(ROI_ArrCplx/mean(ROI_ArrCplx),'b');
plot(ROI_ArrAbs/mean(ROI_ArrAbs),'r');

FIT.ExpDisp = '';
FIT.saveable = 'no';
FIT.label = '';

Status2('done','',2);
Status2('done','',3);
