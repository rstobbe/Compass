%=====================================================
%
%=====================================================

function [ROICREATE,err] = CreateRoiFromImage_v1b_Func(ROICREATE,INPUT)

Status2('busy','Create Roi From Image',2);
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
MASK = ROICREATE.MASK;
clear INPUT;

%---------------------------------------------
% Create Mask
%--------------------------------------------- 
func = str2func([ROICREATE.maskfunc,'_Func']);  
INPUT.Im = IMG.Im;                  
[MASK,err] = func(MASK,INPUT);
if err.flag
    return
end
MASK.Mask(isnan(MASK.Mask)) = 0;

%---------------------------------------------
% Create ROI
%--------------------------------------------- 
ROI = ImageRoiClass;
ROI.ExternalDefineRoiMask('Axial',size(MASK.Mask),MASK.Mask);
ROI.SetInfo('CreateRoiFromImage');
ROICREATE.ROI(1) = ROI;
ROICREATE.Suffix = MASK.Name;
ROICREATE.Path{1} = '';

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'',ROICREATE.method,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
ROICREATE.PanelOutput = [PanelOutput;MASK.PanelOutput];
ROICREATE.ExpDisp = PanelStruct2Text(ROICREATE.PanelOutput);

Status2('done','',2);
Status2('done','',3);



