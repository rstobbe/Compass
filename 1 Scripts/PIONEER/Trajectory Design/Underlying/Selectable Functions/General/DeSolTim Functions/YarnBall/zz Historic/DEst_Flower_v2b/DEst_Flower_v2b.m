%====================================================
% (v2b)
%       - update for RWSUI_BA
%====================================================

function [SCRPTipt,DESOL,err] = DEst_Flower_v2b(SCRPTipt,DESOLipt)

Status2('busy','Get DE solution timing info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
DESOL = struct();
DESOL.radevfunc = DESOLipt.('RadSolEvfunc').Func;
DESOL.fineness = str2double(DESOLipt.('Fineness'));

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