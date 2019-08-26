%=========================================================
% (v1c)
%       - update for function splitting
%=========================================================

function [SCRPTipt,WRTG,err] = WrtGrad_NFilesV_v1c(SCRPTipt,WRTGipt)

Status2('busy','Write Gradient Files',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

WRTG = struct();
%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = WRTGipt.Struct.labelstr;
if not(isfield(WRTGipt,[CallingLabel,'_Data']))
    if isfield(WRTGipt.('GradDefLoc').Struct,'selectedfile')
        file = WRTGipt.('GradDefLoc').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load GradDefLoc';
            ErrDisp(err);
            return
        else
            WRTGipt.([CallingLabel,'_Data']).('GradDefLoc_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load GradDefLoc';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Return Input
%---------------------------------------------
WRTG.method = WRTGipt.Func;
WRTG.sysgmax = str2double(WRTGipt.('sysGmax'));
WRTG.GradDefLoc = WRTGipt.([CallingLabel,'_Data']).('GradDefLoc_Data').path;
WRTG.dowrite = WRTGipt.('WriteGrads');

Status2('done','',2);
Status2('done','',3);
