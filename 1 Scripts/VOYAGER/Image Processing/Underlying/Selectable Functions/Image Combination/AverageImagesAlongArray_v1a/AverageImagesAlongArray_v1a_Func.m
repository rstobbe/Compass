%===========================================
% 
%===========================================

function [AVE,err] = AverageImagesAlongArray_v1a_Func(AVE,INPUT)

Status2('busy','AverageImagesAlongArray',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
IMG = INPUT.IMG;
clear INPUT;

%---------------------------------------------
% Test
%--------------------------------------------- 
if length(IMG) > 1
    err.flag = 1;
    err.msg = 'Use Multiple Image Averaging Script';
    return
end
IMG = IMG{1};

%---------------------------------------------
% Test
%--------------------------------------------- 
IMG.Im = mean(IMG.Im,AVE.dim);

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',AVE.method,'Output'};
Panel(3,:) = {'Averaging Dimension',AVE.dim,'Output'};
AVE.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Return
%---------------------------------------------
AVE.FigureName = 'Averaged Image';
AVE.IMG = IMG;

Status2('done','',2);
Status2('done','',3);

