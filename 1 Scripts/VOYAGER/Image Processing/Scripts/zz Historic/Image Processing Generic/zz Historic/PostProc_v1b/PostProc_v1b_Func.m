%===========================================
% 
%===========================================

function [PPROC,err] = PostProc_v1b_Func(PPROC,INPUT)

Status('busy','Post Processing');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
IMG = INPUT.IMG;
PFUNC = INPUT.PFUNC;
DISP = INPUT.DISP;
clear INPUT;

%---------------------------------------------
% Sort Out Input
%---------------------------------------------
Im = IMG.Im;
ReconPars = IMG.ReconPars;
PanelOutput = IMG.PanelOutput;

%---------------------------------------------
% Create Base Image for Display
%---------------------------------------------
func = str2func([PPROC.postprocfunc,'_Func']);  
INPUT.Im = Im;
INPUT.ReconPars = ReconPars;
[PFUNC,err] = func(PFUNC,INPUT);
if err.flag
    return
end
clear INPUT;
Im = PFUNC.Im;

%---------------------------------------------
% Display
%---------------------------------------------
func = str2func([PPROC.dispfunc,'_Func']);  
INPUT.Im = Im;
INPUT.Name = 'write from pfunc...';
[DISP,err] = func(DISP,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
PPROC.ReconPars = ReconPars;
PPROC.PanelOutput = PanelOutput;
PPROC.Im = Im;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);

