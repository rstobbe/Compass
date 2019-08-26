%==============================================
% 
%==============================================

function [ROI,err] = DropEdgesVOI_v1a_Func(ROI,INPUT)

Status2('busy','Drop VOI Edges',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Common Variables
%---------------------------------------------
SmearIm = INPUT.SmearIm;
RoiIn = INPUT.RoiMask;
clear INPUT

%--------------------------------------
% Determine ROI
%--------------------------------------  
RoiOut = zeros(size(SmearIm));
RoiOut(SmearIm >= ROI.minirs) = 1;

test0 = max(SmearIm(:)) 
test1 = sum(RoiIn(:))
test2 = sum(RoiOut(:))

Mask = logical(RoiOut);
ROI.Mask = RoiIn & Mask;

Status2('done','',3);