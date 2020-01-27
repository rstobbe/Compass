%=========================================================
% 
%=========================================================

function [FIT,err] = FitDistTool_v1a_Func(FIT,INPUT)

Status2('busy','Fit Distribution',2);
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
ROI_Arr = ROI.GetROIDataArray(IMAGEANLZ);

%---------------------------------------------
% Remove Zeros
%---------------------------------------------
ROI_Arr2 = [];
for i = 1:length(ROI_Arr)
    if ROI_Arr(i) ~= 0
        ROI_Arr2 = [ROI_Arr2 ROI_Arr(i)];       % want to estimate a Rician distribution which can't handle zeros.
    end
end
length(ROI_Arr2);

%---------------------------------------------
% Fit ROI (absolute value)
%---------------------------------------------
dfittool(abs(ROI_Arr2));

FIT.ExpDisp = '';
FIT.saveable = 'no';
FIT.label = '';

Status2('done','',2);
Status2('done','',3);
