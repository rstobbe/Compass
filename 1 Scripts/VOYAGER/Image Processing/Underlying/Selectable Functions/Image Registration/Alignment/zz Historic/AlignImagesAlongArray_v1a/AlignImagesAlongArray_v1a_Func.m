%=========================================================
% 
%=========================================================

function [ALGN,err] = AlignImagesToolbox_v1a_Func(ALGN,INPUT)

Status2('busy','Align Images',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG{1};
Im = IMG.Im;
StatIm = Im(:,:,:,1);
%pixdim = IMG.IMDISP.ImInfo.pixdim;
clear INPUT;

%---------------------------------------------
% Register
%---------------------------------------------
%SpaceRef = imref3d(size(StatIm),pixdim(1),pixdim(2),pixdim(3));        % doesn't work
SpaceRef = imref3d(size(StatIm));
[optimizer,metric] = imregconfig('monomodal');
optimizer.MaximumStepLength = 0.1; 
optimizer.MinimumStepLength = 1e-2;                                     % accuracy/time (changing others = detrimental @ first test)

sz = size(Im);
RegIm = zeros(sz);
RegIm(:,:,:,1) = StatIm;

% tform = imregtform(abs(Im(:,:,:,4)),SpaceRef,abs(StatIm),SpaceRef,'rigid',optimizer,metric,'DisplayOptimization',1);
% RegIm(:,:,:,2) = imwarp(Im(:,:,:,4),tform,'OutputView',SpaceRef);

for n = 2:sz(4)
    Status2('busy',['Image: ',num2str(n)],3);
    tform = imregtform(abs(Im(:,:,:,n)),SpaceRef,abs(StatIm),SpaceRef,'rigid',optimizer,metric);
    RegIm(:,:,:,n) = imwarp(Im(:,:,:,n),tform,'OutputView',SpaceRef);
end
    
%---------------------------------------------
% Return
%---------------------------------------------
IMG.Im = RegIm;
ALGN.IMG = IMG;

Status2('done','',2);
Status2('done','',3);

