%=====================================================
% (LR1)
%   - no gradient response include
% (v1b)
%   - add 'build' function (for template based imp)
%=====================================================

function [SCRPTipt,GWFM,err] = GWFM_Spiral1_v1b(SCRPTipt,GWFMipt)

Status('busy','Create Gradient Waveforms');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
GWFM.method = GWFMipt.Func;
GWFM.GFfunc = GWFMipt.('GFixfunc').Func;
GWFM.TENDfunc = GWFMipt.('TEndfunc').Func;
GWFM.GCOMPfunc = GWFMipt.('GCompfunc').Func;
GWFM.GBLDfunc = GWFMipt.('GBuildfunc').Func;

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
GCOMPipt = GWFMipt.('GCompfunc');
if isfield(GWFMipt,([CallingFunction,'_Data']))
    if isfield(GWFMipt.GWFMfunc_Data,('GCompfunc_Data'))
        GCOMPipt.GCompfunc_Data = GWFMipt.GWFMfunc_Data.GCompfunc_Data;
    end
end
GFipt = GWFMipt.('GFixfunc');
if isfield(GWFMipt,([CallingFunction,'_Data']))
    if isfield(GWFMipt.GWFMfunc_Data,('GFixfunc_Data'))
        GFipt.GFfunc_Data = GWFMipt.GWFMfunc_Data.GFfunc_Data;
    end
end
GBLDipt = GWFMipt.('GBuildfunc');
if isfield(GWFMipt,([CallingFunction,'_Data']))
    if isfield(GWFMipt.GWFMfunc_Data,('GBuildfunc_Data'))
        GBLDipt.GBuildfunc_Data = GWFMipt.GWFMfunc_Data.GBuildfunc_Data;
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
% Get GComp Function Info
%------------------------------------------
func = str2func(GWFM.GCOMPfunc);           
[SCRPTipt,GCOMP,err] = func(SCRPTipt,GCOMPipt);
if err.flag
    return
end

%------------------------------------------
% Get GF Function Info
%------------------------------------------
func = str2func(GWFM.GFfunc);           
[SCRPTipt,GF,err] = func(SCRPTipt,GFipt);
if err.flag
    return
end

%------------------------------------------
% Get GBuild Function Info
%------------------------------------------
func = str2func(GWFM.GBLDfunc);           
[SCRPTipt,GBLD,err] = func(SCRPTipt,GBLDipt);
if err.flag
    return
end

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
GWFM.TEND = TEND;
GWFM.GCOMP = GCOMP;
GWFM.GF = GF;
GWFM.GBLD = GBLD;

Status2('done','',2);
Status2('done','',3);
