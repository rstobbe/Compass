%===========================================
% 
%===========================================

function [FILTIM,err] = FilterImageLoad_v1a_Func(FILTIM,INPUT)

Status2('busy','Filter Image',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
IMG = INPUT.IMG;
FILT = INPUT.FILT;
clear INPUT;

%---------------------------------------------
% Filter
%---------------------------------------------
func = str2func([FILTIM.filterfunc,'_Func']);  
INPUT.Im = IMG.Im;
if isfield(IMG,'ReconPars')
    INPUT.ReconPars = IMG.ReconPars;
else
    INPUT.ReconPars = '';
end
[FILT,err] = func(FILT,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
FILTIM.Im = FILT.Im;
FILTIM.ReconPars = FILT.ReconPars;
FILTIM.PanelOutput = IMG.PanelOutput;

Status2('done','',2);
Status2('done','',3);

