%==================================================
% (v1a)
%       - 
%==================================================

function [SCRPTipt,DESMETH,err] = DesMeth_YarnBall_v1a(SCRPTipt,DESMETHipt)

Status2('busy','Get acceleration constraint info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
DESMETH.method = DESMETHipt.Func;
DESMETH.spinfunc = DESMETHipt.('Spinfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
SPINipt = DESMETHipt.('Spinfunc');
if isfield(DESMETHipt,('Spinfunc_Data'))
    SPINipt.Spinfunc_Data = DESMETHipt.Spinfunc_Data;
end

%------------------------------------------
% Get Spinning Function Info
%------------------------------------------
func = str2func(DESMETH.spinfunc);           
[SCRPTipt,SPIN,err] = func(SCRPTipt,SPINipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
DESMETH.SPIN = SPIN;

Status2('done','',2);
Status2('done','',3);

