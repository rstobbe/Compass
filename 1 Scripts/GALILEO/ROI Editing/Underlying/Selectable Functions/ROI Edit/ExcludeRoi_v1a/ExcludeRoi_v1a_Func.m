%===========================================
% 
%===========================================

function [MASK,err] = ExcludeRoi_v1a_Func(MASK,INPUT)

Status2('busy','Mask',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
ROIARR = INPUT.ROI;
clear INPUT;

%---------------------------------------------
% Get ROI Mask
%--------------------------------------------- 
load(MASK.ROI.selectedfile,'ROI');
ExcludeMask = ROI.roimask;
MASK = rmfield(MASK,'ROI');

%---------------------------------------------
% Turn ROI into Mask
%---------------------------------------------
for n = 1:length(ROIARR)
    if isfield(ROIARR(n),'loc')
        load(ROIARR(n).loc,'ROI');
    else
        ROI = ROIARR(n);
    end
    Mask0 = ROI.roimask;

    Mask = Mask0 & not(logical(ExcludeMask));
    
    ROI.ExternalDefineRoiMask('Axial',size(Mask),Mask);
    ROI.SetInfo('ExcludeRoi');
    MASK.ROI(n) = ROI;
end

MASK.Suffix = 'Exclude';

%---------------------------------------------
% Return
%---------------------------------------------
Status2('done','',2);
Status2('done','',3);

