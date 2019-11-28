%=========================================================
% 
%=========================================================

function [COR,err] = VoxelCorrect_v1a_Func(COR,INPUT)

Status2('busy','Adjust Voxel Size',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG{1};
clear INPUT;

%---------------------------------------------
% Voxel Scale
%---------------------------------------------
IMG.IMDISP.ImInfo.pixdim = IMG.IMDISP.ImInfo.pixdim*COR.voxscale;

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',COR.method,'Output'};
Panel(3,:) = {'VoxScale',COR.voxscale,'Output'};
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
if strfind(IMG.name,'.mat') 
    IMG.name = IMG.name(1:end-4);
end
if strfind(IMG.name,'.nii')
    IMG.name = IMG.name(1:end-4);
end
IMG.name = [IMG.name,'_VScl'];
COR.IMG = IMG;

Status2('done','',2);
Status2('done','',3);