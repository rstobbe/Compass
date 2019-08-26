%=========================================================
% 
%=========================================================

function [FITTOP,err] = RoiDistFit_v1a_Func(FITTOP,INPUT)

Status('busy','Fit ROI Distributions');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
FIT = INPUT.FIT;
ROIS = INPUT.ROIS;
clear INPUT

%---------------------------------------------
% Fit Distribution
%---------------------------------------------
func = str2func([FITTOP.fitdistfunc,'_Func']);  
for n = 1:length(ROIS)
    INPUT.ROI = ROIS(n).DataArr;
    [FIT,err] = func(FIT,INPUT);
    if err.flag
        return
    end
end
clear INPUT;

%---------------------------------------------
% Fit Distribution
%---------------------------------------------
FITTOP.ExpDisp = FIT.ExpDisp;
FITTOP.saveable = FIT.saveable;

Status2('done','',2);
Status2('done','',3);
