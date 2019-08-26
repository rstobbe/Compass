%=====================================================
% (v1h)
%       - Separate k-Space sampling function
%=====================================================

function [SCRPTipt,IMETH,err] = ImpMeth_LRstandard_v1h(SCRPTipt,IMETHipt)

Status2('busy','Standard LR Implementation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
IMETH.method = IMETHipt.Func;
IMETH.orientfunc = IMETHipt.('Orientfunc').Func;
IMETH.desoltimfunc = IMETHipt.('DeSolTimfunc').Func;
IMETH.accconstfunc = IMETHipt.('ConstEvolfunc').Func;
IMETH.TENDfunc = IMETHipt.('TEndfunc').Func;
IMETH.SysRespfunc = IMETHipt.('SysRespfunc').Func;
IMETH.kSampfunc = IMETHipt.('kSampfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingFunction = IMETHipt.Struct.labelstr;
ORNTipt = IMETHipt.('Orientfunc');
if isfield(IMETHipt,([CallingFunction,'_Data']))
    if isfield(IMETHipt.([CallingFunction,'_Data']),('Orientfunc_Data'))
        ORNTipt.Orientfunc_Data = IMETHipt.([CallingFunction,'_Data']).Orientfunc_Data;
    end
end
DESOLipt = IMETHipt.('DeSolTimfunc');
if isfield(IMETHipt,([CallingFunction,'_Data']))
    if isfield(IMETHipt.([CallingFunction,'_Data']),('DeSolTimfunc_Data'))
        DESOLipt.DeSolTimfunc_Data = IMETHipt.([CallingFunction,'_Data']).DeSolTimfunc_Data;
    end
end
CACCipt = IMETHipt.('ConstEvolfunc');
if isfield(IMETHipt,([CallingFunction,'_Data']))
    if isfield(IMETHipt.([CallingFunction,'_Data']),('ConstEvolfunc_Data'))
        CACCipt.ConstEvolfunc_Data = IMETHipt.([CallingFunction,'_Data']).ConstEvolfunc_Data;
    end
end
TENDipt = IMETHipt.('TEndfunc');
if isfield(IMETHipt,([CallingFunction,'_Data']))
    if isfield(IMETHipt.([CallingFunction,'_Data']),('TEndfunc_Data'))
        TENDipt.TENDfunc_Data = IMETHipt.([CallingFunction,'_Data']).TEndfunc_Data;
    end
end
SYSRESPipt = IMETHipt.('SysRespfunc');
if isfield(IMETHipt,([CallingFunction,'_Data']))
    if isfield(IMETHipt.([CallingFunction,'_Data']),('SysRespfunc_Data'))
        SYSRESPipt.SysRespfunc_Data = IMETHipt.([CallingFunction,'_Data']).SysRespfunc_Data;
    end
end
KSMPipt = IMETHipt.('kSampfunc');
if isfield(IMETHipt,([CallingFunction,'_Data']))
    if isfield(IMETHipt.([CallingFunction,'_Data']),('kSampfunc_Data'))
        KSMPipt.kSampfunc_Data = IMETHipt.([CallingFunction,'_Data']).kSampfunc_Data;
    end
end

%------------------------------------------
% Get Function Info
%------------------------------------------
func = str2func(IMETH.orientfunc);           
[SCRPTipt,ORNT,err] = func(SCRPTipt,ORNTipt);
if err.flag
    return
end
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
func = str2func(IMETH.SysRespfunc);           
[SCRPTipt,SYSRESP,err] = func(SCRPTipt,SYSRESPipt);
if err.flag
    return
end
func = str2func(IMETH.kSampfunc);           
[SCRPTipt,KSMP,err] = func(SCRPTipt,KSMPipt);
if err.flag
    return
end


%------------------------------------------
% Return
%------------------------------------------
IMETH.ORNT = ORNT;
IMETH.DESOL = DESOL;
IMETH.CACC = CACC;
IMETH.TEND = TEND;
IMETH.SYSRESP = SYSRESP;
IMETH.KSMP = KSMP;

Status2('done','',2);
Status2('done','',3);