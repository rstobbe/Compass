%=========================================================
% (v2a)
%       - write parameters for variable gradient delays
%=========================================================

function [SCRPTipt,WRTPRM,err] = WrtParam_LRnoVSL_v2a(SCRPTipt,WRTPRMipt)

Status2('busy','Write Projection Set Parameter Files',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

WRTPRM = struct();
%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = WRTPRMipt.Struct.labelstr;
if not(isfield(WRTPRMipt,[CallingLabel,'_Data']))
    if isfield(WRTPRMipt.('ParamDefLoc').Struct,'selectedfile')
        file = WRTPRMipt.('ParamDefLoc').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load ParamDefLoc';
            ErrDisp(err);
            return
        else
            WRTPRMipt.([CallingLabel,'_Data']).('ParamDefLoc_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load ParamDefLoc';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Return Input
%---------------------------------------------
WRTPRM.method = WRTPRMipt.Func;
WRTPRM.ParamDefLoc = WRTPRMipt.([CallingLabel,'_Data']).('ParamDefLoc_Data').path;

Status2('done','',2);
Status2('done','',3);
