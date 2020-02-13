%===========================================
% 
%===========================================

function [EDIT,err] = CombineRois_v1a_Func(EDIT,INPUT)

Status2('busy','Combine Rois',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
ROIARR = INPUT.ROI;
clear INPUT;

%---------------------------------------------
% Combine Rois Masks
%---------------------------------------------
Mask = ROIARR(1).roimask;
for n = 2:length(ROIARR)
    Mask = Mask | ROIARR(n).roimask;
end
ROI = ROIARR(1);
ROI.ExternalDefineRoiMask('Axial',size(Mask),Mask);
ROI.SetInfo('CombineRois');
EDIT.ROI = ROI;

EDIT.Suffix = 'Combine';

%---------------------------------------------
% Return
%---------------------------------------------
Status2('done','',2);
Status2('done','',3);

