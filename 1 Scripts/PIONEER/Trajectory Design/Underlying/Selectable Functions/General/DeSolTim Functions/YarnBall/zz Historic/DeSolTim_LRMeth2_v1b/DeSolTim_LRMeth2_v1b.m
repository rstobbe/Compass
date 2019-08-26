%====================================================
% (v1b)
%    - allow solution beyond radial fraction of 1
%       (for spiral effect)
%====================================================

function [SCRPTipt,DESOL,err] = DeSolTim_LRMeth2_v1b(SCRPTipt,DESOLipt)

Status2('busy','Get DE solution timing info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
DESOL = struct();
DESOL.radevfunc = DESOLipt.('RadSolEvfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
RADEVipt = DESOLipt.('RadSolEvfunc');
if isfield(DESOLipt,('RadSolEvfunc_Data'))
    RADEVipt.RadSolEvfunc_Data = DESOLipt.RadSolEvfunc_Data;
end

%------------------------------------------
% Get RadEvfunc Info
%------------------------------------------
func = str2func(DESOL.radevfunc);           
[SCRPTipt,RADEV,err] = func(SCRPTipt,RADEVipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
DESOL.RADEV = RADEV;

Status2('done','',2);
Status2('done','',3);