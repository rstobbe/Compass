%===========================================
% 
%===========================================

function [PROCIMG,err] = GenericPostProcessing_v1c_Func(PROCIMG,INPUT)

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
clear INPUT;

%---------------------------------------------
% Process Image
%---------------------------------------------
func = str2func([PROCIMG.procfunc,'_Func']);  
INPUT.IMG = IMG;                                    % may be an array of images (subfunc must decide if it can handle)
INPUT.SCRPTipt = SCRPTipt;
INPUT.SCRPTGBL = SCRPTGBL;
[PROC,err] = func(PROC,INPUT);
if err.flag
    return
end
if isfield(PROC,'SCRPTipt');
    SCRPTipt = PROC.SCRPTipt;
end
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
PROCIMG.IMG = PROC.IMG;
PROCIMG.SCRPTipt = SCRPTipt;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);

