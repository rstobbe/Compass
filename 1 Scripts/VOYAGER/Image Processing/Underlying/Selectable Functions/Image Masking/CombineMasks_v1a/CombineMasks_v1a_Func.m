%=====================================================
%
%=====================================================

function [MASK,err] = CombineMasks_v1a_Func(MASK,INPUT)

Status2('busy','Combine Masks',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
IMG = INPUT.IMG;
clear INPUT;

%---------------------------------------------
% Combine ROIs
%---------------------------------------------
Mask = IMG{1}.Im;
Mask(isnan(Mask)) = 0;
for n = 2:length(IMG)
    Mask0 = IMG{n}.Im;
    Mask0(isnan(Mask0)) = 0;
    Mask = and(Mask,Mask0);
end
IMG = IMG{1};
IMG.Im = Mask;

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',MASK.method,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
if isfield(IMG,'PanelOutput')
    IMG.PanelOutput = [IMG.PanelOutput;PanelOutput];
else
    IMG.PanelOutput = [PanelOutput];
end
IMG.ExpDisp = PanelStruct2Text(IMG.PanelOutput);
IMG.IMDISP.ImInfo.info = IMG.ExpDisp;

%---------------------------------------------
% Return
%---------------------------------------------
if strfind(IMG.name,'.')
    IMG.name = IMG.name(1:end-4);
end
IMG.name = [IMG.name,'_Comb'];
MASK.IMG = IMG;

Status2('done','',2);
Status2('done','',3);



