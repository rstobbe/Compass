%=====================================================
% (v1a)
%    
%=====================================================

function [SCRPTipt,IMETH,err] = ImpMeth_Cones_v1a(SCRPTipt,IMETHipt)

Status2('busy','Implement Cones',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
IMETH.method = IMETHipt.Func;
IMETH.tsmpfunc = IMETHipt.('TrajSampfunc').Func;
IMETH.imptypefunc = IMETHipt.('ImpTypefunc').Func;
IMETH.tendfunc = IMETHipt.('TrajEndfunc').Func;
IMETH.ksampfunc = IMETHipt.('kSampfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingFunction = IMETHipt.Struct.labelstr;
IMPTYPEipt = IMETHipt.('ImpTypefunc');
if isfield(IMETHipt,([CallingFunction,'_Data']))
    if isfield(IMETHipt.([CallingFunction,'_Data']),('ImpTypefunc_Data'))
        IMPTYPEipt.ImpTypefunc_Data = IMETHipt.([CallingFunction,'_Data']).ImpTypefunc_Data;
    end
end
TSMPipt = IMETHipt.('TrajSampfunc');
if isfield(IMETHipt,([CallingFunction,'_Data']))
    if isfield(IMETHipt.([CallingFunction,'_Data']),('TrajSampfunc_Data'))
        TSMPipt.TrajSampfunc_Data = IMETHipt.([CallingFunction,'_Data']).TrajSampfunc_Data;
    end
end
TENDipt = IMETHipt.('TrajEndfunc');
if isfield(IMETHipt,([CallingFunction,'_Data']))
    if isfield(IMETHipt.([CallingFunction,'_Data']),('TrajEndfunc_Data'))
        TENDipt.TrajEndfunc_Data = IMETHipt.([CallingFunction,'_Data']).TrajEndfunc_Data;
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
func = str2func(IMETH.imptypefunc);           
[SCRPTipt,IMPTYPE,err] = func(SCRPTipt,IMPTYPEipt);
if err.flag
    return
end
func = str2func(IMETH.tsmpfunc);           
[SCRPTipt,TSMP,err] = func(SCRPTipt,TSMPipt);
if err.flag
    return
end
func = str2func(IMETH.tendfunc);           
[SCRPTipt,TEND,err] = func(SCRPTipt,TENDipt);
if err.flag
    return
end
func = str2func(IMETH.ksampfunc);           
[SCRPTipt,KSMP,err] = func(SCRPTipt,KSMPipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
IMETH.TSMP = TSMP;
IMETH.IMPTYPE = IMPTYPE;
IMETH.TEND = TEND;
IMETH.KSMP = KSMP;

Status2('done','',2);
Status2('done','',3);

