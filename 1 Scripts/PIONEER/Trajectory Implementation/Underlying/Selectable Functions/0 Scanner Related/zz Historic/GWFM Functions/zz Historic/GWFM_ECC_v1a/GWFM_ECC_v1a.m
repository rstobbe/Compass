%=====================================================
% (v1e)
%   - measure and save relative SRA (init step and max) 
%=====================================================

function [SCRPTipt,GWFM,err] = GWFM_GSRA_v1e(SCRPTipt,GWFMipt)

Status('busy','Create Gradient Waveforms');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
GWFM.SRAfunc = GWFMipt.('GSRAfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingFunction = GWFMipt.Struct.labelstr;
GSRAipt = GWFMipt.('GSRAfunc');
if isfield(GWFM,([CallingFunction,'_Data']))
    if isfield(GWFMipt.GWFMfunc_Data,('GSRAfunc_Data'))
        GSRAipt.GSRAfunc_Data = GWFMipt.GWFMfunc_Data.GSRAfunc_Data;
    end
end

%------------------------------------------
% Get GSRA Function Info
%------------------------------------------
func = str2func(GWFM.SRAfunc);           
[SCRPTipt,GSRA,err] = func(SCRPTipt,GSRAipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
GWFM.GSRA = GSRA;

Status2('done','',2);
Status2('done','',3);