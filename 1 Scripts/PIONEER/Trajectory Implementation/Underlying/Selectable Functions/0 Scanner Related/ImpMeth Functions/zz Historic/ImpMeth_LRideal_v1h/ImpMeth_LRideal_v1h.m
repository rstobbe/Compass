%=====================================================
% (v1h)
%       - start
%=====================================================

function [SCRPTipt,IMETH,err] = ImpMeth_LRideal_v1h(SCRPTipt,IMETHipt)

Status2('busy','Implement Ideal LR',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
IMETH.method = IMETHipt.Func;
IMETH.kSampfunc = IMETHipt.('kSampfunc').Func;
IMETH.desoltimfunc = IMETHipt.('DeSolTimfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingFunction = IMETHipt.Struct.labelstr;
DESOLipt = IMETHipt.('DeSolTimfunc');
if isfield(IMETHipt,([CallingFunction,'_Data']))
    if isfield(IMETHipt.([CallingFunction,'_Data']),('DeSolTimfunc_Data'))
        DESOLipt.DeSolTimfunc_Data = IMETHipt.([CallingFunction,'_Data']).DeSolTimfunc_Data;
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
func = str2func(IMETH.desoltimfunc);           
[SCRPTipt,DESOL,err] = func(SCRPTipt,DESOLipt);
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
IMETH.DESOL = DESOL;
IMETH.KSMP = KSMP;

Status2('done','',2);
Status2('done','',3);
