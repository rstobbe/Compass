%===========================================
% 
%===========================================

function [DISP,err] = DisplayCorr_v1a_Func(DISP,INPUT)

Status2('busy','Display Correction',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
IMG1 = INPUT.IMG1;
IMG2 = INPUT.IMG2;
PLOT = DISP.PLOT;
clear INPUT;

%-------------------------------------------------
% Images
%-------------------------------------------------
Im1 = abs((IMG1.Im)/2);
Im2 = abs((IMG2.Im)/2);

%-------------------------------------------------
% Base Mask
%-------------------------------------------------
BaseMask = ones(size(Im1));
BaseMask(Im1 < 0.05*max(Im1(:))) = NaN;

%---------------------------------------------
% Plot Correction
%---------------------------------------------
[x,y,z] = size(Im1);
Image = zeros([x,y,z,2]);
Image(:,:,:,1) = Im1.*BaseMask;
Image(:,:,:,2) = ((Im2-Im1)./Im1).*BaseMask;
func = str2func([DISP.plotfunc,'_Func']);  
INPUT.Image = Image;
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end
clear INPUT;
title('Correction');

%---------------------------------------------
% Return
%---------------------------------------------
Status2('done','',2);
Status2('done','',3);

