%=====================================================
% (v1a)
%       - 
%=====================================================

function [SCRPTipt,IMETH,err] = ImpMeth_QuantizedCATPI_v1b(SCRPTipt,IMETHipt)

Status2('busy','Get TPI Implementation Method',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
IMETH.method = IMETHipt.Func;
IMETH.orientfunc = IMETHipt.('Orientfunc').Func;
IMETH.iseg = str2double(IMETHipt.('iGseg'));
IMETH.trajcompletefunc = IMETHipt.('TrajCompletefunc').Func;
IMETH.qvecslvfunc = IMETHipt.('QVecSlvfunc').Func;
IMETH.ksampfunc = IMETHipt.('kSampfunc').Func;
IMETH.steprespfunc = IMETHipt.('StepRespfunc').Func;

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
TCPLTipt = IMETHipt.('TrajCompletefunc');
if isfield(IMETHipt,([CallingFunction,'_Data']))
    if isfield(IMETHipt.([CallingFunction,'_Data']),('TrajCompletefunc_Data'))
        TCPLTipt.TrajCompletefunc_Data = IMETHipt.([CallingFunction,'_Data']).TrajCompletefunc_Data;
    end
end
GQNTipt = IMETHipt.('QVecSlvfunc');
if isfield(IMETHipt,([CallingFunction,'_Data']))
    if isfield(IMETHipt.([CallingFunction,'_Data']),('QVecSLVfunc_Data'))
        GQNTipt.QVecSlvfunc_Data = IMETHipt.([CallingFunction,'_Data']).QVecSlvfunc_Data;
    end
end
KSMPipt = IMETHipt.('kSampfunc');
if isfield(IMETHipt,([CallingFunction,'_Data']))
    if isfield(IMETHipt.([CallingFunction,'_Data']),('kSampfunc_Data'))
        KSMPipt.kSampfunc_Data = IMETHipt.([CallingFunction,'_Data']).kSampfunc_Data;
    end
end
STEPRESPipt = IMETHipt.('StepRespfunc');
if isfield(IMETHipt,([CallingFunction,'_Data']))
    if isfield(IMETHipt.([CallingFunction,'_Data']),('StepRespfunc_Data'))
        STEPRESPipt.StepRespfunc_Data = IMETHipt.([CallingFunction,'_Data']).StepRespfunc_Data;
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
func = str2func(IMETH.trajcompletefunc);           
[SCRPTipt,TCPLT,err] = func(SCRPTipt,TCPLTipt);
if err.flag
    return
end
func = str2func(IMETH.qvecslvfunc);           
[SCRPTipt,GQNT,err] = func(SCRPTipt,GQNTipt);
if err.flag
    return
end
func = str2func(IMETH.ksampfunc);           
[SCRPTipt,KSMP,err] = func(SCRPTipt,KSMPipt);
if err.flag
    return
end
func = str2func(IMETH.steprespfunc);           
[SCRPTipt,STEPRESP,err] = func(SCRPTipt,STEPRESPipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
IMETH.ORNT = ORNT;
IMETH.TCPLT = TCPLT;
IMETH.GQNT = GQNT;
IMETH.KSMP = KSMP;
IMETH.STEPRESP = STEPRESP;

Status2('done','',2);
Status2('done','',3);