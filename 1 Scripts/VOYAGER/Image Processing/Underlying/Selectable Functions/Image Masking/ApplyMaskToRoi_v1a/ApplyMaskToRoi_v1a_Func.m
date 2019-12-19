%=====================================================
%
%=====================================================

function [MASK,err] = ApplyMaskToRoi_v1a_Func(MASK,INPUT)

Status2('busy','Apply Mask To ROI',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
IMG = INPUT.IMG{1};
clear INPUT;

%---------------------------------------------
% Turn ROI into Mask
%---------------------------------------------
load(MASK.ROI.selectedfile,'ROI');
sz1 = size(IMG.Im);
sz2 = size(ROI.roimask);
if sz1(1)~=sz2(1) || sz1(2)~=sz2(2) || sz1(3)~=sz2(3)
    err.flag = 1;
    err.msg = 'Image and ROI do not match';
end

%---------------------------------------------
% Mask ROI
%---------------------------------------------
roimask = IMG.Im.*ROI.roimask;
roimask(isnan(roimask)) = 0;
ROI.ExternalDefineRoiMask(ROI.baseroiorient,ROI.roiimsize,roimask);
[file,path] = uiputfile('*.mat','Save ROI',[IMG.path,'m',ROI.roiname]);
if path == 0
    err.flag = 4;
    err.mgs = '';
    return
end
save([path,file],'ROI');

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',MASK.method,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
if isfield(IMG,'PanelOutput')
    IMG.PanelOutput = [IMG.PanelOutput;PanelOutput];
else
    IMG.PanelOutput = [PanelOutput];
end
IMG.ExpDisp = PanelStruct2Text(IMG.PanelOutput);
IMG.IMDISP.ImInfo.info = IMG.ExpDisp;

%---------------------------------------------
% Return
%---------------------------------------------
IMG.name = ['MASK_',ROI.roiname];
MASK.IMG = IMG;

Status2('done','',2);
Status2('done','',3);



