%=========================================================
% 
%=========================================================

function [ALGN,err] = AlignImagesThroughArray_v1a_Func(ALGN,INPUT)

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
ImArrayLen = size(IMG);
StatIm = IMG{1}.Im(:,:,:,1);                        % Align to first

%---------------------------------------------
% Register
%---------------------------------------------
SpaceRef = imref3d(size(StatIm));
[optimizer,metric] = imregconfig('monomodal');
optimizer.MaximumStepLength = 0.1; 
optimizer.MinimumStepLength = 1e-2;                                     % accuracy/time (changing others = detrimental @ first test)

sz = size(IMG{1}.Im);
for m = 1:ImArrayLen
    RegIm = zeros(sz);
    Im = IMG{m}.Im;
    for n = 1:sz(4)
        Status2('busy',['Image: ',num2str(n)],3);
        tform = imregtform(abs(Im(:,:,:,n)),SpaceRef,abs(StatIm),SpaceRef,'rigid',optimizer,metric);
        RegIm(:,:,:,n) = imwarp(Im(:,:,:,n),tform,'OutputView',SpaceRef);
    end
end
    
%---------------------------------------------
% Return
%---------------------------------------------
IMG.Im = RegIm;
ALGN.IMG = IMG;

Status2('done','',2);
Status2('done','',3);

