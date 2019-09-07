%=====================================================
%
%=====================================================

function [MASKTOP,err] = CreateRoiFromImage_v1a_Func(MASKTOP,INPUT)

Status2('busy','Create Roi From Image',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
IMG = INPUT.IMG{1};
Im = IMG.Im;
MASK = MASKTOP.MASK;
clear INPUT;

%---------------------------------------------
% Create Mask
%--------------------------------------------- 
func = str2func([MASKTOP.maskfunc,'_Func']);  
INPUT.Im = Im;                  
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
[file,path] = uiputfile('*.mat','Save ROI',[IMG.path,'ROI_',IMG.file(1:end-4)]);
save([path,file],'ROI');

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',MASKTOP.method,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
if isfield(IMG,'PanelOutput')
    IMG.PanelOutput = [IMG.PanelOutput;PanelOutput];
else
    IMG.PanelOutput = PanelOutput;
end
IMG.ExpDisp = PanelStruct2Text(IMG.PanelOutput);
IMG.IMDISP.ImInfo.info = IMG.ExpDisp;

%---------------------------------------------
% Return
%---------------------------------------------
if strfind(IMG.name,'.')
    IMG.name = IMG.name(1:end-4);
end
IMG.name = [IMG.name,'_MASK'];
MASKTOP.IMG = IMG;

Status2('done','',2);
Status2('done','',3);



