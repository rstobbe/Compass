%===========================================
% 
%===========================================

function [PROCIMG,err] = ProcessImage_v1d_Func(PROCIMG,INPUT)

Status('busy','Post-Process Image');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Input
%---------------------------------------------
IMG = INPUT.IMG;
PROC = INPUT.PROC;
SCRPTipt = INPUT.SCRPTipt;
SCRPTGBL = INPUT.SCRPTGBL;
ExtRun = INPUT.ExtRun;
clear INPUT;

%---------------------------------------------
% Process Image
%---------------------------------------------
func = str2func([PROCIMG.procfunc,'_Func']);  
INPUT.IMG = IMG;                                    % may be an array of images (subfunc must decide if it can handle)
INPUT.SCRPTipt = SCRPTipt;
INPUT.SCRPTGBL = SCRPTGBL;
INPUT.ExtRun = ExtRun;
[PROC,err] = func(PROC,INPUT);
if isfield(PROC,'SCRPTipt')
    PROCIMG.SCRPTipt = PROC.SCRPTipt;
end
if err.flag
    return
end
clear INPUT;
if isfield(PROC,'CompassDisplay')
    PROCIMG.CompassDisplay = PROC.CompassDisplay;
end

%---------------------------------------------
% Return
%---------------------------------------------
PROCIMG.IMG = PROC.IMG;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);

