%=========================================================
% (v1a)
%     
%=========================================================

function [SCRPTipt,WRTG,err] = WrtGrad_NFilesMRS_v1a(SCRPTipt,WRTGipt)

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
WRTG.sysgmaxX = str2double(WRTGipt.('sysGmaxX'));
WRTG.sysgmaxY = str2double(WRTGipt.('sysGmaxY'));
WRTG.sysgmaxZ = str2double(WRTGipt.('sysGmaxZ'));
WRTG.GradDefLoc = WRTGipt.([CallingLabel,'_Data']).('GradDefLoc_Data').path;
WRTG.dowrite = WRTGipt.('WriteGrads');

Status2('done','',2);
Status2('done','',3);
