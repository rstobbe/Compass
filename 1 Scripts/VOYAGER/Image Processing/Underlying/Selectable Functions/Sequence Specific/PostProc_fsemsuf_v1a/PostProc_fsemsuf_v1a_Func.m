%=====================================================
%
%=====================================================

function [PSTP,err] = PostProc_fsemsuf_v1a_Func(PSTP,INPUT)

Status2('busy','Post Processing',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG;
Im = IMG.Im;
ReconPars = IMG.ReconPars;
ISHIM = PSTP.ISHIM;
clear INPUT;

%----------------------------------------------
% Intensity Shim
%----------------------------------------------
func = str2func([PSTP.ishimfunc,'_Func']);  
INPUT.Im = Im;
INPUT.ReconPars = ReconPars;
INPUT.visuals = PSTP.visuals;
[ISHIM,err] = func(ISHIM,INPUT);
if err.flag
    return
end
Im = ISHIM.Im;
clear INPUT;

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'ISHIM',PSTP.ishimfunc,'Output'};
Panel(1,:) = {'','','Output'};
PSTP.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

%----------------------------------------------
% Return
%----------------------------------------------
IMG.Im = Im;
PSTP.IMG = IMG;

Status2('done','',2);
Status2('done','',3);



