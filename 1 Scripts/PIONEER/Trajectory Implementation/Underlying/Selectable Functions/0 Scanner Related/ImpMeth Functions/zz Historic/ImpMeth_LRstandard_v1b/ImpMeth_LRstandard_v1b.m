%=====================================================
% (v1b)
%       - Only one Test Trajectory
%=====================================================

function [SCRPTipt,IMETH,err] = ImpMeth_LRstandard_v1b(SCRPTipt,IMETHipt)

Status2('busy','Standard LR Implementation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
IMETH.method = IMETHipt.Func;
IMETH.desoltimfunc = IMETHipt.('DeSolTimfunc').Func;
IMETH.accconstfunc = IMETHipt.('ConstEvolfunc').Func;
IMETH.TENDfunc = IMETHipt.('TEndfunc').Func;
IMETH.GCOMPfunc = IMETHipt.('GCompfunc').Func;
IMETH.SysRespfunc = IMETHipt.('SysRespfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingFunction = IMETHipt.Struct.labelstr;
DESOLipt = IMETHipt.('DeSolTimfunc');
if isfield(IMETH,([CallingFunction,'_Data']))
    if isfield(IMETH.([CallingFunction,'_Data']),('DeSolTimfunc_Data'))
        DESOLipt.DeSolTimfunc_Data = IMETHipt.([CallingFunction,'_Data']).DeSolTimfunc_Data;
    end
end
CACCipt = IMETHipt.('ConstEvolfunc');
if isfield(IMETH,([CallingFunction,'_Data']))
    if isfield(IMETH.([CallingFunction,'_Data']),('ConstEvolfunc_Data'))
        CACCipt.ConstEvolfunc_Data = IMETHipt.([CallingFunction,'_Data']).ConstEvolfunc_Data;
    end
end
TENDipt = IMETHipt.('TEndfunc');
if isfield(IMETHipt,([CallingFunction,'_Data']))
    if isfield(IMETH.([CallingFunction,'_Data']),('TEndfunc_Data'))
        TENDipt.TENDfunc_Data = IMETHipt.([CallingFunction,'_Data']).TEndfunc_Data;
    end
end
GCOMPipt = IMETHipt.('GCompfunc');
if isfield(IMETHipt,([CallingFunction,'_Data']))
    if isfield(IMETH.([CallingFunction,'_Data']),('GCompfunc_Data'))
        GCOMPipt.GCompfunc_Data = IMETHipt.([CallingFunction,'_Data']).GCompfunc_Data;
    end
end
SYSRESPipt = IMETHipt.('SysRespfunc');
if isfield(IMETHipt,([CallingFunction,'_Data']))
    if isfield(IMETH.([CallingFunction,'_Data']),('SysRespfunc_Data'))
        SYSRESPipt.SysRespfunc_Data = IMETHipt.([CallingFunction,'_Data']).SysRespfunc_Data;
    end
end

%------------------------------------------
% Get Function Info
%------------------------------------------
func = str2func(IMETH.desoltimfunc);           
[SCRPTipt,DESOL,err] = func(SCRPTipt,DESOLipt);
if err.flag
    return
end
func = str2func(IMETH.accconstfunc);           
[SCRPTipt,CACC,err] = func(SCRPTipt,CACCipt);
if err.flag
    return
end
func = str2func(IMETH.TENDfunc);           
[SCRPTipt,TEND,err] = func(SCRPTipt,TENDipt);
if err.flag
    return
end
func = str2func(IMETH.GCOMPfunc);           
[SCRPTipt,GCOMP,err] = func(SCRPTipt,GCOMPipt);
if err.flag
    return
end
func = str2func(IMETH.SysRespfunc);           
[SCRPTipt,SYSRESP,err] = func(SCRPTipt,SYSRESPipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
IMETH.DESOL = DESOL;
IMETH.CACC = CACC;
IMETH.TEND = TEND;
IMETH.GCOMP = GCOMP;
IMETH.SYSRESP = SYSRESP;

Status2('done','',2);
Status2('done','',3);