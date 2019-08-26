%=========================================================
% 
%=========================================================

function [OUTPUT,err] = ROIDistFit_v1a_Func(FIT,INPUT)

global ROISOFINTEREST
global CURFIG

Status('busy','Fit ROI Distribution');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
OUTPUT = struct();

%---------------------------------------------
% Get Input
%---------------------------------------------
clear INPUT

%---------------------------------------------
% Test
%---------------------------------------------
if sum(ROISOFINTEREST) > 1
    err.flag = 1;
    err.msg = 'Only 1 ROI of Interest Allowed';
    return
end

if sum(ROISOFINTEREST) == 0
    err.flag = 1;
    err.msg = 'One ROI Must Be Selected';
    return
end
roinum = find(ROISOFINTEREST == 1);

%---------------------------------------------
% Extract ROI as an Array
%---------------------------------------------
[ROI_Arr] = Extract_ROI_Array_v2a(roinum,CURFIG);

%---------------------------------------------
% Remove Zeros
%---------------------------------------------
ROI_Arr2 = [];
for i = 1:length(ROI_Arr)
    if ROI_Arr(i) ~= 0
        ROI_Arr2 = [ROI_Arr2 ROI_Arr(i)];       % want to estimate a Rician distribution which can't handle zeros.
    end
end
length(ROI_Arr2)

%---------------------------------------------
% Fit ROI
%---------------------------------------------
dfittool(ROI_Arr2);


