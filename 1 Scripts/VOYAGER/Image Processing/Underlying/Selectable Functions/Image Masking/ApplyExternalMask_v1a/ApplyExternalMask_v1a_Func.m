%=====================================================
%
%=====================================================

function [MASK,err] = ApplyExternalMask_v1a_Func(MASK,INPUT)

Status2('busy','ApplyExternalMask',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
IMG = INPUT.IMG{1};
Im = IMG.Im;
Mask = INPUT.IMG{2}.Im;
clear INPUT;

%---------------------------------------------
% Mask
%--------------------------------------------- 
Im = Im.*Mask;
IMG.Im = Im;

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',MASK.method,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
IMG.PanelOutput = [IMG.PanelOutput;PanelOutput];
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



