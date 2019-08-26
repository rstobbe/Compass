%=========================================================
% 
%=========================================================

function [CALCTOP,err] = CalcROIPrec_v1a_Func(CALCTOP,INPUT)

global ROISOFINTEREST
global CURFIG

Status('busy','Calculate ROI Precision');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
CALC = INPUT.CALC;
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
    err.msg = 'Must Select an ROI';
    return
end
roinum = find(ROISOFINTEREST == 1);

%---------------------------------------------
% Extract ROI Mask
%---------------------------------------------
[ROI] = Extract_ROI_Mask_v1a(roinum,CURFIG);

%---------------------------------------------
% Extract ROI Array
%---------------------------------------------
%[ROIarr] = Extract_ROI_Array_v2a(roinum,CURFIG);
%SigMean = mean(ROIarr);

%---------------------------------------------
% Calculate Precision
%---------------------------------------------
func = str2func([CALCTOP.calcprecfunc,'_Func']);  
INPUT.ROI = ROI;
[CALC,err] = func(CALC,INPUT);
if err.flag
    return
end
clear INPUT;

CALCTOP.CALC = CALC;

Status2('done','',2);
Status2('done','',3);
