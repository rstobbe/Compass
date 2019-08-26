%=====================================================
% (v3a)
%     
%=====================================================

function [SCRPTipt,IMETH,err] = ImpMeth_LRideal_v3a(SCRPTipt,IMETHipt)

Status2('busy','Implement Ideal LR',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
IMETH.method = IMETHipt.Func;
IMETH.desoltimfunc = IMETHipt.('DeSolTimfunc').Func;
IMETH.psmpfunc = IMETHipt.('ProjSampfunc').Func;
IMETH.tsmpfunc = IMETHipt.('TrajSampfunc').Func;

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
PSMPipt = IMETHipt.('ProjSampfunc');
if isfield(IMETHipt,([CallingFunction,'_Data']))
    if isfield(IMETHipt.([CallingFunction,'_Data']),('ProjSampfunc_Data'))
        PSMPipt.ProjSampfunc_Data = IMETHipt.([CallingFunction,'_Data']).ProjSampfunc_Data;
    end
end
TSMPipt = IMETHipt.('TrajSampfunc');
if isfield(IMETHipt,([CallingFunction,'_Data']))
    if isfield(IMETHipt.([CallingFunction,'_Data']),('TrajSampfunc_Data'))
        PSMPipt.TrajSampfunc_Data = IMETHipt.([CallingFunction,'_Data']).TrajSampfunc_Data;
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
func = str2func(IMETH.psmpfunc);           
[SCRPTipt,PSMP,err] = func(SCRPTipt,PSMPipt);
if err.flag
    return
end
func = str2func(IMETH.tsmpfunc);           
[SCRPTipt,TSMP,err] = func(SCRPTipt,TSMPipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
IMETH.DESOL = DESOL;
IMETH.PSMP = PSMP;
IMETH.TSMP = TSMP;

Status2('done','',2);
Status2('done','',3);
