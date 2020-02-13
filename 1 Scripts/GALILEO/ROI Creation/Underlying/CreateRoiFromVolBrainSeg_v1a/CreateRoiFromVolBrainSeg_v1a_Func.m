%=====================================================
%
%=====================================================

function [ROICREATE,err] = CreateRoiFromVolBrainSeg_v1a_Func(ROICREATE,INPUT)

Status2('busy','Create Roi From VolBrain Segmentation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
IMG = ROICREATE.IMG;
if length(IMG) > 1
    err.flag = 1;
    err.msg = 'Just One Image';
    return
end
IMG = IMG{1};
clear INPUT;

%---------------------------------------------
% Get Input
%--------------------------------------------- 
Mask = zeros(size(IMG.Im));
Mask(IMG.Im == ROICREATE.segnum) = 1;

%---------------------------------------------
% Create ROI
%--------------------------------------------- 
ROI = ImageRoiClass;
ROI.ExternalDefineRoiMask('Axial',size(Mask),Mask);
ROI.SetInfo('CreateRoiFromVolBrain');
ROICREATE.ROI(1) = ROI;
ROICREATE.Suffix = ['VB',num2str(ROICREATE.segnum)];
ROICREATE.Path{1} = '';

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'',ROICREATE.method,'Output'};
ROICREATE.PanelOutput = cell2struct(Panel,{'label','value','type'},2);
ROICREATE.ExpDisp = PanelStruct2Text(ROICREATE.PanelOutput);

Status2('done','',2);
Status2('done','',3);



