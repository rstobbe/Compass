%====================================================
%  
%====================================================

function [B1CORR,err] = B1correction_v1b_Func(B1CORR,INPUT)

Status('busy','B1-Correction');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG;
RESZ = INPUT.RESZ;
CORF = INPUT.CORF;
DISP = INPUT.DISP;
clear INPUT;

%---------------------------------------------
% Sort Out Input
%---------------------------------------------
if iscell(IMG)
    if length(IMG)~= 2
        err.flag = 1;
        err.msg = 'Load 2 Images';
        return
    end
    IMG1 = IMG{1};
    IMG2 = IMG{2};
    if not(strcmp(IMG1.ImageType,'Image'))
        err.flag = 1;
        err.msg = 'First File Should be an Image';
        return
    end
    if not(strcmp(IMG2.ImageType,'B1Map'))
        err.flag = 1;
        err.msg = 'Second File Should be a B1Map';
        return
    end     
    ReconPars = IMG1.ReconPars;
    PanelOutput = IMG1.PanelOutput;
    ExpPars = IMG1.ExpPars;
    ExpDisp = IMG1.ExpDisp;
    Im0 = IMG1.Im;
    ReconParsMap = IMG2.ReconPars;
    B1Map = IMG2.Im(:,:,:,2);                   % Should have a flag to confirm right
else
    error;      % not supported yet
end

%---------------------------------------------
% Resize Images If Needed
%---------------------------------------------
func = str2func([B1CORR.resizefunc,'_Func']);  
INPUT.ReconPars0 = ReconPars;
INPUT.ReconPars1 = ReconParsMap;
INPUT.Im = B1Map;
[RESZ,err] = func(RESZ,INPUT);
if err.flag
    return
end
clear INPUT;
B1Map = RESZ.Im;

%---------------------------------------------
% B1 Correction
%---------------------------------------------
func = str2func([B1CORR.corrfunc,'_Func']);  
INPUT.Im = Im0;
INPUT.B1Map = B1Map;
INPUT.Sequence = ExpPars.Sequence;
[CORF,err] = func(CORF,INPUT);
if err.flag
    return
end
clear INPUT;
Im = CORF.Im;

%---------------------------------------------
% Convert NaN to zero 
%---------------------------------------------
Im(isnan(Im)) = 0;

%---------------------------------------------
% Display
%---------------------------------------------
func = str2func([B1CORR.dispfunc,'_Func']);  
INPUT.Im0 = Im0;
INPUT.ImNew = Im;
[DISP,err] = func(DISP,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
B1CORR.Im = Im;
B1CORR.ReconPars = ReconPars;
B1CORR.ExpPars = ExpPars;
B1CORR.ExpDisp = ExpDisp;
B1CORR.PanelOutput = PanelOutput;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);

