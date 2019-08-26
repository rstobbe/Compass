%====================================================
% (v1e)
%   - match DesType
%====================================================

function [SCRPTipt,IMPTYPE,err] = ImpType_OutInDualEchoOptions_v1e(SCRPTipt,IMPTYPEipt)

Status2('busy','Get ImpType',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
IMPTYPE.method = IMPTYPEipt.Func;   
IMPTYPE.sysrespfunc = IMPTYPEipt.('SysRespfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingFunction = IMPTYPEipt.Struct.labelstr;
SYSRESPipt = IMPTYPEipt.('SysRespfunc');
if isfield(IMPTYPEipt,([CallingFunction,'_Data']))
    if isfield(IMPTYPEipt.([CallingFunction,'_Data']),('SysRespfunc_Data'))
        SYSRESPipt.SysRespfunc_Data = IMPTYPEipt.([CallingFunction,'_Data']).SysRespfunc_Data;
    end
end

%------------------------------------------
% Get Function Info
%------------------------------------------
func = str2func(IMPTYPE.sysrespfunc);           
[SCRPTipt,SYSRESP,err] = func(SCRPTipt,SYSRESPipt);
if err.flag
    return
end

%------------------------------------------
% Other
%------------------------------------------
FINMETH.method = 'FinMeth_ConstrainThenEnd_v1a';

%------------------------------------------
% Return
%------------------------------------------
IMPTYPE.SYSRESP = SYSRESP;
IMPTYPE.FINMETH = FINMETH;

Status2('done','',3);