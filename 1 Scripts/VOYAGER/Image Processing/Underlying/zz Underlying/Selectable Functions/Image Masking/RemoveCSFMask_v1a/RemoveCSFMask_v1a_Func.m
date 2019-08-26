%===========================================
% 
%===========================================

function [MASK,err] = RemoveCSFMask_v1a_Func(MASK,INPUT)

Status2('busy','Mask',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
IMG = INPUT.IMG;
clear INPUT;

%---------------------------------------------
% Get Image
%--------------------------------------------- 
if length(IMG) > 1
    err.flag = 1;
    err.msg = '''RemoveCSFMask'' only handles 1 image at a time';
    return
end
IMG = IMG{1};
Im = IMG.Im;

%---------------------------------------------
% Intensity 
%---------------------------------------------
Mask = zeros(size(Im));

if strcmp(MASK.direction,'Positive')
    Mask(abs(Im) >= MASK.threshold) = 1;
elseif strcmp(MASK.direction,'Negative')
    Mask(abs(Im) <= MASK.threshold) = 1;
end
test = sum(Mask(:))

%---------------------------------------------
% Expand
%---------------------------------------------
dim = MASK.maskexpand*2 + 1;
kernel = ones(dim,dim,dim);

LMask = logical(convn(Mask,kernel,'same'));
test2 = sum(LMask(:))

%---------------------------------------------
% Create
%---------------------------------------------
Mask = ones(size(Im));
Mask(LMask) = NaN;

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',MASK.method,'Output'};
MASK.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%---------------------------------------------
% Return
%---------------------------------------------
IMG.Im = Im.*Mask;
MASK.IMG = IMG;
MASK.FigureName = 'RemoveCSFMask';

Status2('done','',2);
Status2('done','',3);

