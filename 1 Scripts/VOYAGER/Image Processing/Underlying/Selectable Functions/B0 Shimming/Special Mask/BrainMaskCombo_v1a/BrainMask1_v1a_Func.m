%===========================================
% 
%===========================================

function [MASK,err] = BrainMask1_v1a_Func(MASK,INPUT)

Status2('done','Mask',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%----------------------------------------------
% Get input
%----------------------------------------------
AbsIm = INPUT.AbsIm;
ReconPars = INPUT.ReconPars;
figno = INPUT.figno;
SCRPTipt = INPUT.SCRPTipt;
SCRPTGBL = INPUT.SCRPTGBL;
fMap = INPUT.fMap;
MFOV = MASK.MFOV;
MFRQ = MASK.MFRQ;
clear INPUT;

%---------------------------------------------
% FoV Mask
%---------------------------------------------
func = str2func([MASK.maskfovfunc,'_Func']);  
INPUT.AbsIm = AbsIm;
INPUT.fMap = fMap;
INPUT.ReconPars = ReconPars;
INPUT.figno = figno;
INPUT.SCRPTipt = SCRPTipt;
INPUT.SCRPTGBL = SCRPTGBL;
[MFOV,err] = func(MFOV,INPUT);
if err.flag
    return
end
if isfield(MFOV,'SCRPTipt');
    MASK.SCRPTipt = MFOV.SCRPTipt;
end
MaskFoV = MFOV.Mask;
clear INPUT;

%---------------------------------------------
% Freq Mask
%---------------------------------------------
func = str2func([MASK.maskfreqfunc,'_Func']);  
INPUT.fMap = fMap;
[MFRQ,err] = func(MFRQ,INPUT);
if err.flag
    return
end
MaskFreq = MFRQ.Mask;
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
if isempty(MaskFreq)
    MASK.Mask = MaskFoV;
else
    MASK.Mask = MaskFoV.*MaskFreq;
end


Status2('done','',2);
Status2('done','',3);

