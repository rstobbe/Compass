%=========================================================
% 
%=========================================================

function [ALGN,err] = AlignMultiImagesToAverage_v1a_Func(ALGN,INPUT)

Status2('busy','Align Multiple Images To Average',2);
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
StatIm = abs(IMG{ALGN.pass1alignim}.Im(:,:,:,1,1,1));                       
SpaceRef = imref3d(size(StatIm));
[optimizer,metric] = imregconfig('monomodal');
optimizer.MaximumStepLength = 0.1; 
optimizer.MinimumStepLength = 1e-2;                                     % accuracy/time (changing others = detrimental @ first test)

%---------------------------------------------
% First Pass Alignment
%---------------------------------------------
StatIm = abs(IMG{ALGN.pass1alignim}.Im(:,:,:,1,1,1));                       
AveIm = StatIm;
for m = 2:ImArrayLen
    Status2('busy',['First Pass Alignment: ',num2str(m)],3);
    JiggleIm = abs(IMG{m}.Im(:,:,:,1,1,1));
    tform = imregtform(JiggleIm,SpaceRef,StatIm,SpaceRef,'rigid',optimizer,metric);    
    %test = tform.T
    if strcmp(ALGN.average,'Abs')
        AveIm = imwarp(abs(IMG{m}.Im(:,:,:,1,1,1)),tform,'OutputView',SpaceRef) + AveIm;
    elseif strcmp(ALGN.average,'Complex')
        rRegIm = imwarp(real(IMG{m}.Im(:,:,:,1,1,1)),tform,'OutputView',SpaceRef);
        iRegIm = imwarp(imag(IMG{m}.Im(:,:,:,1,1,1)),tform,'OutputView',SpaceRef);
        AveIm = rRegIm + 1i*iRegIm + AveIm;
    end
end
AveIm = AveIm/ImArrayLen;

%---------------------------------------------
% Alignment to Average
%---------------------------------------------
StatIm = abs(AveIm);
RegIm = zeros([size(StatIm) ImArrayLen+1]);
for m = 1:ImArrayLen
    Status2('busy',['Align To Average: ',num2str(m)],3);
    JiggleIm = abs(IMG{m}.Im(:,:,:,1,1,1));
    tform = imregtform(JiggleIm,SpaceRef,StatIm,SpaceRef,'rigid',optimizer,metric);    
    %test = tform.T
    rRegIm = imwarp(real(IMG{m}.Im(:,:,:,1,1,1)),tform,'OutputView',SpaceRef);
    iRegIm = imwarp(imag(IMG{m}.Im(:,:,:,1,1,1)),tform,'OutputView',SpaceRef);
    RegIm(:,:,:,m) = rRegIm + 1i*iRegIm;
end
RegIm = mean(RegIm,4);

%---------------------------------------------
% Output
%---------------------------------------------   
IMG = IMG{1};
IMG.Im = RegIm;

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

