%===========================================
% 
%===========================================

function [SUM,err] = SumImages_v1a_Func(SUM,INPUT)

Status2('busy','SumImages',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
%IMG = INPUT.IMG{1};
IMG = INPUT.IMG;
clear INPUT;

%---------------------------------------------
% Build
%--------------------------------------------- 
% sz = size(IMG{1}.Im);
% ImArray = zeros([sz length(IMG)]);
% for n = 1:length(IMG)
%     ImArray(:,:,:,n) = IMG{n}.Im;
% end

%repeat--------------
%Im = IMG.Im;
% Im(:,:,:,8) = IMG.Im(:,:,:,7);
% Im(:,:,:,9) = IMG.Im(:,:,:,7);
%test = size(Im)
%--------------------

%AveIm = mean(Im,4);
%IMG.Im = AveIm;

Im = IMG{1}.Im;
for n = 2:length(IMG)
    Im = Im + IMG{n}.Im;
end
IMG = IMG{1};
IMG.Im = Im;

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',SUM.method,'Output'};
SUM.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Return
%---------------------------------------------
SUM.FigureName = 'Summed Image';
SUM.IMG = IMG;

Status2('done','',2);
Status2('done','',3);

