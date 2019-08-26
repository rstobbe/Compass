%===========================================
% 
%===========================================

function [TEST,err] = ImageTesting_v1a_Func(TEST,INPUT)

Status('busy','Test Image');
Status2('busy','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
IMG = INPUT.IMG;
MASK = INPUT.MASK;
BASE = INPUT.BASE;
DISP = INPUT.DISP;
TST = INPUT.TST;
SCRPTipt = INPUT.SCRPTipt;
SCRPTGBL = INPUT.SCRPTGBL;
clear INPUT;

%---------------------------------------------
% Sort Out Input
%---------------------------------------------
type = 1;
if iscell(IMG)
    type = 2;
end
if type == 1
    if isfield(IMG,'ImageType');
        if not(strcmp(IMG.ImageType,'Image'))
            err.flag = 1;
            err.msg = 'Input File Not Image';
            return
        end
    end
    if isfield(IMG.ExpPars,'Array')
        Array = IMG.ExpPars.Array;
    else
        Array = [];
    end
    Im = IMG.Im;
    PanelOutput = IMG.PanelOutput;
    ReconPars = IMG.ReconPars;
    ExpPars = IMG.ExpPars;
    ExpDisp = IMG.ExpDisp;
    FID = IMG.FID;
elseif type ==2
    error();    % not supported
end

%---------------------------------------------
% Create Base Image for Display
%---------------------------------------------
func = str2func([TEST.baseimfunc,'_Func']);  
INPUT.Im = Im;
INPUT.ExpPars = ExpPars;
[BASE,err] = func(BASE,INPUT);
if err.flag
    return
end
clear INPUT;
BaseIm = BASE.Im;

%---------------------------------------------
% Mask
%---------------------------------------------
func = str2func([TEST.maskfunc,'_Func']);  
INPUT.AbsIm = BaseIm;
INPUT.fMap = [];
INPUT.ReconPars = ReconPars;
INPUT.figno = 100;
INPUT.SCRPTipt = SCRPTipt;
INPUT.SCRPTGBL = SCRPTGBL;
[MASK,err] = func(MASK,INPUT);
if err.flag
    return
end
if isfield(MASK,'SCRPTipt');
    SCRPTipt = MASK.SCRPTipt;
end
Mask = MASK.Mask;
clear INPUT;

%---------------------------------------------
% Test
%---------------------------------------------
func = str2func([TEST.testfunc,'_Func']);  
INPUT.Image = Im;
INPUT.Mask = Mask;
INPUT.ReconPars = ReconPars;
INPUT.BaseIm = BaseIm;
INPUT.ExpPars = ExpPars;
[TST,err] = func(TST,INPUT);
if err.flag
    return
end
clear INPUT;
TstIm = TST.Im;
BaseIm = TST.BaseIm;
%Mask = TST.Mask;

%---------------------------------------------
% Display
%---------------------------------------------
Im = zeros([size(BaseIm) 2]);
Im(:,:,:,1) = BaseIm;
Im(:,:,:,2) = TstIm;
func = str2func([TEST.dispfunc,'_Func']);  
INPUT.Im = Im;
[DISP,err] = func(DISP,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
TEST.Im = Im;
TEST.ImageType = 'Test';
TEST.FID = FID;
TEST.ReconPars = ReconPars;
TEST.ExpPars = ExpPars;
TEST.ExpDisp = ExpDisp;
TEST.PanelOutput = PanelOutput;
TEST.SCRPTipt = SCRPTipt;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);
