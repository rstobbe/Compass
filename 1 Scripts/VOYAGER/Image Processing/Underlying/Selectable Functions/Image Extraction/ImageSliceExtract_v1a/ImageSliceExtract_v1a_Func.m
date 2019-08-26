%=========================================================
% 
%=========================================================

function [SEXT,err] = ImageSliceExtract_v1a_Func(SEXT,INPUT)

Status2('busy','Images Slice Extract',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG;
clear INPUT;

%---------------------------------------------
% Test
%---------------------------------------------
if length(IMG) > 1
    err.flag = 1;
    err.msg = 'Procfunc runs on single image';
    return
end
IMG = IMG{1};

%---------------------------------------------
% Extract Dimensions
%---------------------------------------------
sz = size(IMG.Im);
if strcmp(SEXT.ornt,'Axial')
    IMG.Im = IMG.Im(:,:,SEXT.slice,:,:,:);
elseif strcmp(SEXT.ornt,'Sagittal')
    IMG.Im = IMG.Im(:,SEXT.slice,:,:,:,:);
elseif strcmp(SEXT.ornt,'Coronal')
    IMG.Im = IMG.Im(SEXT.slice,:,:,:,:,:);
end

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',SEXT.method,'Output'};
Panel(3,:) = {'Orientation',SEXT.ornt,'Output'};
Panel(4,:) = {'Slice',SEXT.slice,'Output'};
SEXT.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

PanelOutput = IMG.PanelOutput;
IMG.PanelOutput = [PanelOutput;SEXT.PanelOutput];
IMG.ExpDisp = PanelStruct2Text(PanelOutput);

%---------------------------------------------
% Name
%---------------------------------------------
ind = strfind(IMG.name,'.');
if not(isempty(ind))
    name = IMG.name(1:ind-1);
end 
IMG.name = [name,'_SEXT'];

%---------------------------------------------
% Return
%---------------------------------------------
SEXT.IMG = IMG;
SEXT.FigureName = 'Slice Extract';

Status2('done','',2);
Status2('done','',3);
