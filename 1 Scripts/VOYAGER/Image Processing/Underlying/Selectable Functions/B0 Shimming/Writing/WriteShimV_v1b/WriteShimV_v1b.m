%=========================================================
% (v1b)
%       - Selectable Location
%=========================================================

function[SCRPTipt,WRTSHIM,err] = WriteShimV_v1b(SCRPTipt,WRTSHIMipt)

Status2('busy','Write WRTSHIM File',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
WRTSHIM.method = WRTSHIMipt.Func;

if isfield(WRTSHIMipt.('VarianShim_File').Struct,'selectedfile')
    file = WRTSHIMipt.('VarianShim_File').Struct.selectedfile;
    if not(exist(file,'file'))
        err.flag = 1;
        err.msg = 'VarianShim_File does not exist';
        ErrDisp(err);
        return
    end
end

WRTSHIM.VarianShimFile = file;

Status2('done','',2);
Status2('done','',3);
