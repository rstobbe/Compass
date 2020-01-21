%=========================================================
% 
%=========================================================

function [ALGN,err] = AlignB1ImagesToNaImage_v1a_Func(ALGN,INPUT)

Status2('busy','Align B1 Images to 23Na Image',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG;
clear INPUT;

%---------------------------------------------
% Get Info
%---------------------------------------------
ImArrayLen = length(IMG);
if ImArrayLen == 1
    err.flag = 1;
    err.msg = 'Need at least 2 images';
    return
end

%---------------------------------------------
% Alignment Properties
%---------------------------------------------
pixdim = IMG{1}.IMDISP.ImInfo.pixdim;
StatIm = abs(IMG{1}.Im(:,:,:,1,1,1));  
SpaceRef0 = imref3d(size(StatIm),pixdim(2),pixdim(1),pixdim(3));
[optimizer,metric] = imregconfig('multimodal');
optimizer.InitialRadius = optimizer.InitialRadius/3.5;
% optimizer.InitialRadius = 5e-4;
% optimizer.GrowthFactor = 1.01;
% optimizer.MaximumIterations = 300;
%optimizer.MaximumStepLength = 0.01; 
%optimizer.MinimumStepLength = 1e-2;                                     % accuracy/time (changing others = detrimental @ first test)

%---------------------------------------------
% Alignment
%---------------------------------------------                 
pixdim = IMG{2}.IMDISP.ImInfo.pixdim;
JiggleIm = abs(IMG{2}.Im(:,:,:,1,1,1));
SpaceRef = imref3d(size(JiggleIm),pixdim(2),pixdim(1),pixdim(3));
tform = imregtform(JiggleIm,SpaceRef,StatIm,SpaceRef0,'rigid',optimizer,metric,'DisplayOptimization',1);
TransForm = tform.T
%---
RealIm = real(IMG{2}.Im(:,:,:,1,1,1));
ImagIm = real(IMG{2}.Im(:,:,:,1,1,1));
rRegIm = imwarp(RealIm,SpaceRef,tform,'OutputView',SpaceRef0);
iRegIm = imwarp(ImagIm,SpaceRef,tform,'OutputView',SpaceRef0);
RegIm(:,:,:,1,1,1) = rRegIm + 1i*iRegIm;
%---
RealIm = real(IMG{2}.Im(:,:,:,2,1,1));
ImagIm = real(IMG{2}.Im(:,:,:,2,1,1));
rRegIm = imwarp(RealIm,SpaceRef,tform,'OutputView',SpaceRef0);
iRegIm = imwarp(ImagIm,SpaceRef,tform,'OutputView',SpaceRef0);
RegIm(:,:,:,2,1,1) = rRegIm + 1i*iRegIm;

%---------------------------------------------
% Output
%---------------------------------------------   
IMDISP = IMG{2}.IMDISP;
IMG = IMG{2};                               % could use a fix up somehow here for multiple images
IMG.Im = RegIm;
IMG.IMDISP = IMDISP;
IMG.tform = tform;

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

