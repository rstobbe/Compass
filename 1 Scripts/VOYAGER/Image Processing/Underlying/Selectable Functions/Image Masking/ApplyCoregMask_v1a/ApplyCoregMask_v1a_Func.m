%=====================================================
%
%=====================================================

function [MASK,err] = ApplyCoregMask_v1a_Func(MASK,INPUT)

Status2('busy','Apply Coregistered Mask',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
IMG = INPUT.IMG{1};
Im = IMG.Im;
Mask0 = INPUT.IMG{2}.Im;
clear INPUT;

%---------------------------------------------
% Mask
%--------------------------------------------- 
Mask = NaN*ones(size(Mask0));
Mask(Mask0 >= MASK.minval) = 1; 

Im = Im.*Mask;
IMG.Im = Im;

MASK.MeanVal = abs(nanmean(Im(:)));

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',MASK.method,'Output'};
Panel(3,:) = {'Mean Mask Value',MASK.MeanVal,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);

if isfield(IMG,'PanelOutput')
    IMG.PanelOutput = [IMG.PanelOutput;PanelOutput];
else
    IMG.PanelOutput = PanelOutput;
end
IMG.ExpDisp = PanelStruct2Text(IMG.PanelOutput);
IMG.IMDISP.ImInfo.info = IMG.ExpDisp;

%---------------------------------------------
% Return
%---------------------------------------------
if strfind(IMG.name,'.')
    IMG.name = IMG.name(1:end-4);
end
IMG.name = [IMG.name,'_MASK'];
MASK.IMG = IMG;

Status2('done','',2);
Status2('done','',3);



