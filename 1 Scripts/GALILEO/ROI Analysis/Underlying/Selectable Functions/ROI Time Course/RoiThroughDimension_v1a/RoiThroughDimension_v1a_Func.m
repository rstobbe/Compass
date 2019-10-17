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
sz = IMAGEANLZ.GetBaseImageSize([]);
Len = sz(4)-1;
for n = 1:Len
%for n = 1:sz(4)
    IMAGEANLZ.SetDim4(n);
    ROI_ArrCplx(n) = abs(mean(ROI.GetComplexROIDataArray(IMAGEANLZ)));
    ROI_ArrAbs(n) = mean(abs(ROI.GetComplexROIDataArray(IMAGEANLZ)));
    ROI_Arr(n) = mean(ROI.GetComplexROIDataArray(IMAGEANLZ));    
end

%ROI_Arr = ROI_ArrCplx;

%ROI_Arr = ROI_ArrAbs(1:14);

Slope = [ones(Len,1) (0:Len-1).']\ROI_Arr.';
mdl = fitlm((0:Len-1),ROI_Arr);
[b,bint,r,rint,stats] = regress(ROI_Arr.',[ones(Len,1) (0:Len-1).']);


figure(235); hold on;
% plot((0:Len-1),ROI_ArrCplx,'r');
plot((1:Len),ROI_ArrAbs,'m');
% plot((0:Len-1),real(ROI_Arr),'c');
% plot((0:Len-1),imag(ROI_Arr),'b');
%plot((0:Len-1),Slope(1)+(0:Len-1)*Slope(2),'k');
% plot(ROI_ArrCplx/mean(ROI_ArrCplx),'b');
% plot(ROI_ArrAbs/mean(ROI_ArrAbs),'r');

FIT.ExpDisp = '';
FIT.saveable = 'no';
FIT.label = '';

Status2('done','',2);
Status2('done','',3);
