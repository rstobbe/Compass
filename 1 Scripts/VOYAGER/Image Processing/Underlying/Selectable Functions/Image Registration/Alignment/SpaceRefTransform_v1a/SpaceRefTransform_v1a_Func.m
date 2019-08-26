%=========================================================
% 
%=========================================================

function [ALGN,err] = SpaceRefTransform_v1a_Func(ALGN,INPUT)

Status2('busy','SpaceRefTransform',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG;
clear INPUT;

%---------------------------------------------
% Alignment 
%---------------------------------------------
R =[1 0 0 0;
    0 1 0 0;
    0 0 1 0;
    0 0 0 1;];
tform = affine3d(R);

pixdim = IMG{1}.IMDISP.ImInfo.pixdim;
StatIm = abs(IMG{1}.Im(:,:,:,1,1,1));                       
SpaceRefOut = imref3d(size(StatIm),pixdim(1),pixdim(2),pixdim(3));

pixdim = IMG{2}.IMDISP.ImInfo.pixdim;
JiggleIm = abs(IMG{2}.Im(:,:,:,1,1,1));                       
SpaceRef0 = imref3d(size(JiggleIm),pixdim(1),pixdim(2),pixdim(3));

rRegIm = imwarp(real(IMG{2}.Im(:,:,:,1,1,1)),SpaceRef0,tform,'OutputView',SpaceRefOut);
iRegIm = imwarp(imag(IMG{2}.Im(:,:,:,1,1,1)),SpaceRef0,tform,'OutputView',SpaceRefOut);
RegIm = rRegIm + 1i*iRegIm;

%---------------------------------------------
% Output
%---------------------------------------------   
IMDISP = IMG{1}.IMDISP;
IMG = IMG{2};
IMG.Im = RegIm;
IMG.IMDISP = IMDISP;

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',ALGN.method,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
if isfield(IMG,'PanelOutput')
    IMG.PanelOutput = [IMG.PanelOutput;PanelOutput];
else
    IMG.PanelOutput = PanelOutput;
end
IMG.ExpDisp = PanelStruct2Text(IMG.PanelOutput);

%---------------------------------------------
% Return
%---------------------------------------------
ALGN.IMG = IMG;

Status2('done','',2);
Status2('done','',3);

