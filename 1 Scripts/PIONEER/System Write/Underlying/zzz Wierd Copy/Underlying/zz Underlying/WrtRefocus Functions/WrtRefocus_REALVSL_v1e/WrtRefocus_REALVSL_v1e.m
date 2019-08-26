%=========================================================
% (v1e)
%       - input for refocus lengths
%=========================================================

function [SCRPTipt,WRTRFCS,err] = WrtRefocus_REALVSL_v1e(SCRPTipt,WRTRFCSipt)

Status2('busy','Write Gradient Refocussing Tables',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

WRTRFCS = struct();
%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = WRTRFCSipt.Struct.labelstr;
if not(isfield(WRTRFCSipt,[CallingLabel,'_Data']))
    if isfield(WRTRFCSipt.('RefocusDefLoc').Struct,'selectedfile')
        file = WRTRFCSipt.('RefocusDefLoc').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load RefocusDefLoc';
            ErrDisp(err);
            return
        else
            WRTRFCSipt.([CallingLabel,'_Data']).('RefocusDefLoc_Data').path = file;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load RefocusDefLoc';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Return Input
%---------------------------------------------
WRTRFCS.method = WRTRFCSipt.Func;
WRTRFCS.lengths = WRTRFCSipt.('Lengths');
WRTRFCS.RefocusDefLoc = WRTRFCSipt.([CallingLabel,'_Data']).('RefocusDefLoc_Data').path;

Status2('done','',2);
Status2('done','',3);

