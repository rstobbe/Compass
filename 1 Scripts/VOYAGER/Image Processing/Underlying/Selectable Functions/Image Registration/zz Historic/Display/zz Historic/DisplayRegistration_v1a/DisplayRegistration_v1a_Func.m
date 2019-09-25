%===========================================
% 
%===========================================

function [DISP,err] = DisplayRegistration_v1a_Func(DISP,INPUT)

Status2('busy','Display Registration',2);
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
% Noise Mask
%-------------------------------------------------
AbsIm = abs(IMG1.Im);
BaseMask1 = ones(size(AbsIm));
BaseMask1(AbsIm < 0.05*max(AbsIm(:))) = NaN;

% AbsIm = abs(IMG2.Im);
% BaseMask2 = ones(size(AbsIm));
% BaseMask2(AbsIm < 0.05*max(AbsIm(:))) = NaN;

%---------------------------------------------
% Plot Registration
%---------------------------------------------
[x,y,z] = size(AbsIm);
Image = zeros([x,y,z,2]);
Image(:,:,:,1) = abs(IMG1.Im).*BaseMask1;
%Image(:,:,:,2) = abs(IMG2.Im).*BaseMask2;
Image(:,:,:,2) = abs(IMG2.Im);
func = str2func([DISP.plotfunc,'_Func']);  
INPUT.Image = Image;
[PLOT,err] = func(PLOT,INPUT);
if err.flag
    return
end
clear INPUT;
title('Registration Test');

%---------------------------------------------
% Return
%---------------------------------------------
Status2('done','',2);
Status2('done','',3);

