%=========================================================
% 
%=========================================================

function [ALGN,err] = AlignMultiImagesToFirst_v1b_Func(ALGN,INPUT)

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

%---------------------------------------------
% Alignment Properties
%---------------------------------------------
ALGN.pass1alignim = 1;
ALGN.average = 'Complex';
pixdim = IMG{ALGN.pass1alignim}.IMDISP.ImInfo.pixdim;
StatIm = abs(IMG{ALGN.pass1alignim}.Im(:,:,:,1,1,1));                       
SpaceRef0 = imref3d(size(StatIm),pixdim(1),pixdim(2),pixdim(3));
%[optimizer,metric] = imregconfig('monomodal');
[optimizer,metric] = imregconfig('multimodal');
%optimizer.MaximumStepLength = 0.01; 
%optimizer.MinimumStepLength = 1e-2;                                     % accuracy/time (changing others = detrimental @ first test)

%---------------------------------------------
% Alignment
%---------------------------------------------                 
for m = 1:ImArrayLen
    if m == ALGN.pass1alignim
        continue
    end
    Status2('busy',['Align image ',num2str(m),' to ',num2str(ALGN.pass1alignim)],3);
    pixdim = IMG{m}.IMDISP.ImInfo.pixdim;
    JiggleIm = abs(IMG{m}.Im(:,:,:,1,1,1));
    SpaceRef = imref3d(size(JiggleIm),pixdim(1),pixdim(2),pixdim(3));
    tform = imregtform(JiggleIm,SpaceRef,StatIm,SpaceRef0,'rigid',optimizer,metric,'DisplayOptimization',1);    
    test = tform.T
    if strcmp(ALGN.average,'Abs')
        RegIm = imwarp(abs(IMG{m}.Im(:,:,:,1,1,1)),SpaceRef,tform,'OutputView',SpaceRef0);
    elseif strcmp(ALGN.average,'Complex')
        rRegIm = imwarp(real(IMG{m}.Im(:,:,:,1,1,1)),SpaceRef,tform,'OutputView',SpaceRef0);
        iRegIm = imwarp(imag(IMG{m}.Im(:,:,:,1,1,1)),SpaceRef,tform,'OutputView',SpaceRef0);
        RegIm = rRegIm + 1i*iRegIm;
    end
end

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

