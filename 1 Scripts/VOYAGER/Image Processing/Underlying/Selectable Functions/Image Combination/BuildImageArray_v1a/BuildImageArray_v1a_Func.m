%===========================================
% 
%===========================================

function [ARR,err] = BuildImageArray_v1a_Func(ARR,INPUT)

Status2('busy','Build Image Array',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
IMG = INPUT.IMG;
clear INPUT;

%---------------------------------------------
% Build
%--------------------------------------------- 
sz = size(IMG{1}.Im);
ImArray = zeros([sz length(IMG)]);
for n = 1:length(IMG)
    ImArray(:,:,:,n) = IMG{n}.Im;
end
%AveIm = mean(ImArray,4);

IMG = IMG{1};
IMG.Im = ImArray;

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',ARR.method,'Output'};
ARR.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Return
%---------------------------------------------
ARR.FigureName = 'Image Array';
ARR.IMG = IMG;

Status2('done','',2);
Status2('done','',3);

