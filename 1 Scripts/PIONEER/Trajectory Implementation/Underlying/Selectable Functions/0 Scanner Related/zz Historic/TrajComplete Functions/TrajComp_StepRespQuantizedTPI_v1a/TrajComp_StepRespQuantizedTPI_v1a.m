%====================================================
% (v1a)
%
%====================================================

function [SCRPTipt,TCOMP,err] = TrajComp_StepRespQuantizedTPI_v1a(SCRPTipt,TCOMPipt) 

Status('busy','Complete Quantized TPI Using Step Response');
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return 
%---------------------------------------------
TCOMP.method = TCOMPipt.Func;
TCOMP.tendfunc = TCOMPipt.('TEndfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingFunction = TCOMPipt.Struct.labelstr;
TENDipt = TCOMPipt.('TEndfunc');
if isfield(TCOMPipt,([CallingFunction,'_Data']))
    if isfield(TCOMPipt.([CallingFunction,'_Data']),('TEndfunc_Data'))
        TENDipt.TENDfunc_Data = TCOMPipt.([CallingFunction,'_Data']).TEndfunc_Data;
    end
end

%------------------------------------------
% Get TEND Function Info
%------------------------------------------
func = str2func(TCOMP.tendfunc);           
[SCRPTipt,TEND,err] = func(SCRPTipt,TENDipt);
if err.flag
    return
end

TCOMP.TEND = TEND;

Status2('done','',2);
Status2('done','',3);










