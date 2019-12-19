%=========================================================
% 
%=========================================================

function [ALGN,err] = AlignMultiImagesToFirst_v1c_Func(ALGN,INPUT)

Status2('busy','Align Multiple Images',2);
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
ALGN.average = 'Complex';
pixdim = IMG{1}.IMDISP.ImInfo.pixdim;
StatIm = abs(IMG{1}.Im(:,:,:,1,1,1));  
%-
StatIm(isnan(StatIm)) = 0;
%-
%SpaceRef0 = imref3d(size(StatIm),pixdim(1),pixdim(2),pixdim(3));
SpaceRef0 = imref3d(size(StatIm),pixdim(2),pixdim(1),pixdim(3));
[optimizer,metric] = imregconfig(ALGN.config);
% optimizer.InitialRadius = optimizer.InitialRadius/3.5;
optimizer.InitialRadius = optimizer.InitialRadius/3.5;
% optimizer.InitialRadius = 5e-4;
% optimizer.GrowthFactor = 1.01;
% optimizer.MaximumIterations = 300;

%optimizer.MaximumStepLength = 0.01; 
%optimizer.MinimumStepLength = 1e-2;                                     % accuracy/time (changing others = detrimental @ first test)

%---------------------------------------------
% Alignment
%---------------------------------------------                 
for m = 2:ImArrayLen
    Status2('busy',['Align image ',num2str(m),' to ',num2str(1)],3);
    pixdim = IMG{m}.IMDISP.ImInfo.pixdim;
    JiggleIm = abs(IMG{m}.Im(:,:,:,1,1,1));
    JiggleIm(isnan(JiggleIm)) = 0;
    %SpaceRef = imref3d(size(JiggleIm),pixdim(1),pixdim(2),pixdim(3));
    SpaceRef = imref3d(size(JiggleIm),pixdim(2),pixdim(1),pixdim(3));
    ptform = imregtform(JiggleIm,SpaceRef,StatIm,SpaceRef0,'rigid',optimizer,metric,'DisplayOptimization',1);
    %tform = imregtform(JiggleIm,SpaceRef,StatIm,SpaceRef0,'similarity',optimizer,metric,'DisplayOptimization',1);    
    test = tform.T
    RealIm = real(IMG{m}.Im(:,:,:,1,1,1));
    RealIm(isnan(RealIm)) = 0;
    ImagIm = real(IMG{m}.Im(:,:,:,1,1,1));
    ImagIm(isnan(ImagIm)) = 0;
    rRegIm = imwarp(RealIm,SpaceRef,tform,'OutputView',SpaceRef0);
    iRegIm = imwarp(ImagIm,SpaceRef,tform,'OutputView',SpaceRef0);
    RegIm = rRegIm + 1i*iRegIm;
end

%---------------------------------------------
% Output
%---------------------------------------------   
IMDISP = IMG{1}.IMDISP;
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

