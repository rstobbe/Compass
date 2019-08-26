%=====================================================
% (LR1)
%   - no gradient response include
% (v1b)
%   - add 'build' function (for template based imp)
%=====================================================

function [SCRPTipt,GWFM,err] = GWFM_LR1_v1b(SCRPTipt,GWFMipt)

Status('busy','Create Gradient Waveforms');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
GWFM.method = GWFMipt.Func;
GWFM.IGFfunc = GWFMipt.('GFixfunc').Func;
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
IGFipt = GWFMipt.('GFixfunc');
if isfield(GWFMipt,([CallingFunction,'_Data']))
    if isfield(GWFMipt.GWFMfunc_Data,('GFixfunc_Data'))
        IGFipt.IGFfunc_Data = GWFMipt.GWFMfunc_Data.IGFfunc_Data;
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
% Get IGF Function Info
%------------------------------------------
func = str2func(GWFM.IGFfunc);           
[SCRPTipt,IGF,err] = func(SCRPTipt,IGFipt);
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
GWFM.IGF = IGF;
GWFM.GBLD = GBLD;

Status2('done','',2);
Status2('done','',3);
