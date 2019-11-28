%=====================================================
%
%=====================================================

function [MASK,err] = CreateRoiFromExternalMask_v1a_Func(MASK,INPUT)

Status2('busy','Create Roi From External Mask',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
IMG = INPUT.IMG{1};
Mask = IMG.Im;
clear INPUT;

%---------------------------------------------
% Create ROI
%--------------------------------------------- 
ROI = ImageRoiClass;
ROI.ExternalDefineRoiMask('Axial',size(Mask),Mask);
%[file,path] = uiputfile('*.mat','Save ROI',[IMG.path,'ROI_',IMG.file(1:end-4)]);
[file,path] = uiputfile('*.mat','Save ROI',[IMG.path,'ROI_',IMG.name(1:end-4)]);
save([path,file],'ROI');

MASK.IMG = [];

Status2('done','',2);
Status2('done','',3);



