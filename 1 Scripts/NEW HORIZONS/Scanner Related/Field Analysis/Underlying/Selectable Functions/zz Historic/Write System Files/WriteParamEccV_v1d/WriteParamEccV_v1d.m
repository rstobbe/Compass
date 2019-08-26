%==================================================
% (v1d)
%       - update for function splitting
%==================================================

function [SCRPTipt,WRTP,err] = WriteParamEccV_v1d(SCRPTipt,WRTPipt)

Status2('busy','Get Write Parameter Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

WRTP = [];
%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = WRTPipt.Struct.labelstr;
if not(isfield(WRTPipt,[CallingLabel,'_Data']))
    if isfield(WRTPipt.('ParamDefLoc').Struct,'selectedfile')
        file = WRTPipt.('ParamDefLoc').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load ParamDefLoc';
            ErrDisp(err);
            return
        else
            WRTPipt.([CallingLabel,'_Data']).('ParamDefLoc_Data').path = file;
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
WRTP.method = WRTPipt.Func; 
WRTP.ParamDefLoc = WRTPipt.([CallingLabel,'_Data']).('ParamDefLoc_Data').path;

Status2('done','',2);
Status2('done','',3);


