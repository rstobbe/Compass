%===========================================
% 
%===========================================

function [MSKIMG,err] = MaskImage_v1a_Func(MSKIMG,INPUT)

Status('busy','Mask Image');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
IMG = INPUT.IMG;
MASK = INPUT.MASK;
DISP = INPUT.DISP;
SCRPTipt = INPUT.SCRPTipt;
SCRPTGBL = INPUT.SCRPTGBL;
clear INPUT;

%---------------------------------------------
% Sort Out Input
%---------------------------------------------
if length(IMG) > 1          
    error;                       % for now only supports one image
end
IMG = IMG{1};                  
Im = IMG.Im;
ReconPars = IMG.ReconPars;
if isfield(IMG,'PanelOutput')
    PanelOutput = IMG.PanelOutput;
else
    PanelOutput = struct();
end

%---------------------------------------------
% Mask Image
%---------------------------------------------
func = str2func([MSKIMG.maskfunc,'_Func']);  
INPUT.Im = Im;
INPUT.ReconPars = ReconPars;
INPUT.figno = 100;
INPUT.SCRPTipt = SCRPTipt;
INPUT.SCRPTGBL = SCRPTGBL;
[MASK,err] = func(MASK,INPUT);
if err.flag
    return
end
if isfield(MASK,'SCRPTipt')
    SCRPTipt = MASK.SCRPTipt;
end
Mask = MASK.Mask;
clear INPUT;

%---------------------------------------------
% Mask Image
%---------------------------------------------
Im = Im.*Mask;

%---------------------------------------------
% Display
%---------------------------------------------
func = str2func([MSKIMG.dispfunc,'_Func']);  
INPUT.Im = Im;
INPUT.Name = 'Masked Image';
[DISP,err] = func(DISP,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
MSKIMG.ReconPars = ReconPars;
MSKIMG.PanelOutput = PanelOutput;
MSKIMG.SCRPTipt = SCRPTipt;
MSKIMG.Im = Im;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);

