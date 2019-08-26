%=====================================================
% (v1b)
%   - includes trajectory ending
%=====================================================

function [SCRPTipt,GWFM,err] = GWFM_ECC_v1b(SCRPTipt,GWFMipt)

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
GWFM.GECCfunc = GWFMipt.('GECCfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingFunction = GWFMipt.Struct.labelstr;
TENDipt = GWFMipt.('TEndfunc');
if isfield(GWFMipt,([CallingFunction,'_Data']))
    if isfield(GWFMipt.GWFMfunc_Data,('TEndfunc_Data'))
        TENDipt.TENDfunc_Data = GWFMipt.GWFMfunc_Data.TEndfunc_Data;
    end
end
GECCipt = GWFMipt.('GECCfunc');
if isfield(GWFMipt,([CallingFunction,'_Data']))
    if isfield(GWFMipt.GWFMfunc_Data,('GECCfunc_Data'))
        GECCipt.GECCfunc_Data = GWFMipt.GWFMfunc_Data.GECCfunc_Data;
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

%------------------------------------------
% Get GECC Function Info
%------------------------------------------
func = str2func(GWFM.GECCfunc);           
[SCRPTipt,GECC,err] = func(SCRPTipt,GECCipt);
if err.flag
    return
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
GWFM.TEND = TEND;
GWFM.GECC = GECC;

Status2('done','',2);
Status2('done','',3);
