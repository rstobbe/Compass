%=========================================================
% 
%=========================================================

function [ALGN,err] = AlignImage2to1_v1a_Func(ALGN,INPUT)

Status2('busy','Align Images',2);
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
StatIm = abs(IMG{1}.Im(:,:,:,1));                        % Align to first

%---------------------------------------------
% Register
%---------------------------------------------
SpaceRef = imref3d(size(StatIm));
[optimizer,metric] = imregconfig('monomodal');
optimizer.MaximumStepLength = 0.1; 
optimizer.MinimumStepLength = 1e-2;                                     % accuracy/time (changing others = detrimental @ first test)

sz = size(IMG{1}.Im);
if length(sz) == 3
    sz(4) = 1;
end

Status2('busy',['Image: ',num2str(2)],3);
RegIm = zeros(sz);
JiggleIm = abs(IMG{2}.Im(:,:,:,1));
tform = imregtform(JiggleIm,SpaceRef,StatIm,SpaceRef,'rigid',optimizer,metric);    
%test = tform.T
for n = 1:sz(4)
    rRegIm = imwarp(real(IMG{2}.Im(:,:,:,n)),tform,'OutputView',SpaceRef);
    iRegIm = imwarp(imag(IMG{2}.Im(:,:,:,n)),tform,'OutputView',SpaceRef);
    RegIm(:,:,:,n) = rRegIm + 1i*iRegIm;
end
IMG{2}.Im = RegIm; 
IMG = IMG{2};

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

