%=====================================================
%
%=====================================================

function [MASKTOP,err] = ApplyDefinedMask_v1a_Func(MASKTOP,INPUT)

Status2('busy','ApplyDefinedMask',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%--------------------------------------------- 
IMG = INPUT.IMG{1};
Im = IMG.Im;
MASK = MASKTOP.MASK;
SCRPTipt = INPUT.SCRPTipt;
SCRPTGBL = INPUT.SCRPTGBL;
clear INPUT;

%---------------------------------------------
% Mask
%---------------------------------------------
func = str2func([MASKTOP.maskfunc,'_Func']);  
INPUT.Im = Im;
INPUT.ReconPars = IMG.ReconPars;
INPUT.IMDISP = IMG.IMDISP;
INPUT.figno = 100;
INPUT.SCRPTipt = SCRPTipt;
INPUT.SCRPTGBL = SCRPTGBL;
[MASK,err] = func(MASK,INPUT);
if err.flag
    return
end

Im = Im.*MASK.Mask;
IMG.Im = Im;

%---------------------------------------------
% Add to Panel Output
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',MASKTOP.method,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
IMG.PanelOutput = [IMG.PanelOutput;PanelOutput;MASK.PanelOutput];
IMG.ExpDisp = PanelStruct2Text(IMG.PanelOutput);
IMG.IMDISP.ImInfo.info = IMG.ExpDisp;

%---------------------------------------------
% Return
%---------------------------------------------
if strfind(IMG.name,'.')
    IMG.name = IMG.name(1:end-4);
end
IMG.name = [IMG.name,'_Mask'];
MASKTOP.IMG = IMG;

Status2('done','',2);
Status2('done','',3);



