%=====================================================
% (v1a)
%   - 
%=====================================================

function [SCRPTipt,GWFM,err] = GWFM_noECC_v1a(SCRPTipt,GWFMipt)

Status('busy','Create Gradient Waveforms');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
GWFM.method = GWFMipt.Func;
GWFM.TENDfunc = GWFMipt.('TEndfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingFunction = GWFMipt.Struct.labelstr;
TENDipt = GWFMipt.('TEndfunc');
if isfield(GWFMipt,([CallingFunction,'_Data']))
    if isfield(GWFMipt.GWFMfunc_Data,('TEndfunc_Data'))
        TENDipt.TENDfunc_Data = GWFMipt.GWFMfunc_Data.GSRAfunc_Data;
    end
end

%------------------------------------------
% Get TEND Function Info
%------------------------------------------
func = str2func(GWFM.TENDfunc);           
[SCRPTipt,TEND,err] = func(SCRPTipt,TENDipt);
if err.flag
    return
end


%---------------------------------------------
% Return Panel Input
%---------------------------------------------
GWFM.TEND = TEND;

Status2('done','',2);
Status2('done','',3);
