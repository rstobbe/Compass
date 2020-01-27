%=====================================================
%
%=====================================================

function [ROISEG,err] = SegmentRoiWithImageContrast_v1a_Func(ROISEG,INPUT)

Status2('busy','Segment ROI with Image Contrast',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
IMG = ROISEG.IMG;
if length(IMG) > 1
    err.flag = 1;
    err.msg = 'Just One Image';
    return
end
IMG = IMG{1};
MASK = ROISEG.MASK;
ROI = INPUT.ROI;
clear INPUT;

%---------------------------------------------
% Create Mask
%--------------------------------------------- 
func = str2func([ROISEG.maskfunc,'_Func']);  
INPUT.Im = IMG.Im;                  
[MASK,err] = func(MASK,INPUT);
if err.flag
    return
end
MASK.Mask(isnan(MASK.Mask)) = 0;

%---------------------------------------------
% Create ROI
%--------------------------------------------- 
Roi = ROI.roimask .* MASK.Mask;
ROI.ExternalDefineRoiMask('Axial',size(Roi),Roi);
ROI.SetInfo('SegmentedRoiWithImageContrast');
ROISEG.ROI(1) = ROI;
ROISEG.Suffix = MASK.Name;
ROISEG.Path{1} = '';

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'',ROISEG.method,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
ROISEG.PanelOutput = [PanelOutput;MASK.PanelOutput];
ROISEG.ExpDisp = PanelStruct2Text(ROISEG.PanelOutput);

Status2('done','',2);
Status2('done','',3);



