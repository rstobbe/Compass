%=====================================================
% (v3a)
%     
%=====================================================

function [SCRPTipt,IMETH,err] = ImpMeth_DesignTest_v1a(SCRPTipt,IMETHipt)

Status2('busy','Implement for Design Testing',2);
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
IMETH.radevfunc = IMETHipt.('RadSolEvfunc').Func;
IMETH.accconstfunc = IMETHipt.('ConstEvolfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingFunction = IMETHipt.Struct.labelstr;
RADEVipt = IMETHipt.('RadSolEvfunc');
if isfield(IMETHipt,([CallingFunction,'_Data']))
    if isfield(IMETHipt.([CallingFunction,'_Data']),('RadSolEvfunc_Data'))
        RADEVipt.RadSolEvfunc_Data = IMETHipt.([CallingFunction,'_Data']).RadSolEvfunc_Data;
    end
end
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
CACCipt = IMETHipt.('ConstEvolfunc');
if isfield(IMETHipt,([CallingFunction,'_Data']))
    if isfield(IMETHipt.([CallingFunction,'_Data']),('ConstEvolfunc_Data'))
        CACCipt.ConstEvolfunc_Data = IMETHipt.([CallingFunction,'_Data']).ConstEvolfunc_Data;
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
func = str2func(IMETH.radevfunc);           
[SCRPTipt,RADEV,err] = func(SCRPTipt,RADEVipt);
if err.flag
    return
end
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
func = str2func(IMETH.accconstfunc);           
[SCRPTipt,CACC,err] = func(SCRPTipt,CACCipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
IMETH.DESOL = DESOL;
IMETH.PSMP = PSMP;
IMETH.TSMP = TSMP;
IMETH.CACC = CACC;
IMETH.RADEV = RADEV;

Status2('done','',2);
Status2('done','',3);
