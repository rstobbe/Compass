%=====================================================
% (v1a)
%       - 
%=====================================================

function [SCRPTipt,IMETH,err] = ImpMeth_QuantizedCATPI_v1a(SCRPTipt,IMETHipt)

Status2('busy','Get TPI Implementation Method',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Panel Input
%---------------------------------------------
IMETH.method = IMETHipt.Func;
IMETH.orientfunc = IMETHipt.('Orientfunc').Func;
IMETH.iseg = str2double(IMETHipt.('iSeg'));
IMETH.trajcompletefunc = IMETHipt.('TrajCompletefunc').Func;
IMETH.qvecslvfunc = IMETHipt.('QVecSlvfunc').Func;
IMETH.gsrafunc = IMETHipt.('GSRAfunc').Func;
IMETH.gsrifunc = IMETHipt.('GSRIfunc').Func;
IMETH.ksampfunc = IMETHipt.('kSampfunc').Func;

%---------------------------------------------
% Tests
%---------------------------------------------
CallingLabel = IMETHipt.Struct.labelstr;
if not(isfield(IMETHipt,[CallingLabel,'_Data']))
    if isfield(IMETHipt.('StepResp_File').Struct,'selectedfile')
        file = IMETHipt.('StepResp_File').Struct.selectedfile;
        if not(exist(file,'file'))
            err.flag = 1;
            err.msg = '(Re) Load StepResp_File';
            ErrDisp(err);
            return
        else
            load(file);
            IMETHipt.([CallingLabel,'_Data']).('StepResp_File_Data') = saveData;
        end
    else
        err.flag = 1;
        err.msg = '(Re) Load StepResp_File';
        ErrDisp(err);
        return
    end
end

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingFunction = IMETHipt.Struct.labelstr;
ORNTipt = IMETHipt.('Orientfunc');
if isfield(IMETH,([CallingFunction,'_Data']))
    if isfield(IMETH.([CallingFunction,'_Data']),('Orientfunc_Data'))
        ORNTipt.Orientfunc_Data = IMETHipt.([CallingFunction,'_Data']).Orientfunc_Data;
    end
end
TCPLTipt = IMETHipt.('TrajCompletefunc');
if isfield(IMETH,([CallingFunction,'_Data']))
    if isfield(IMETH.([CallingFunction,'_Data']),('TrajCompletefunc_Data'))
        TCPLTipt.TrajCompletefunc_Data = IMETHipt.([CallingFunction,'_Data']).TrajCompletefunc_Data;
    end
end
GQNTipt = IMETHipt.('QVecSlvfunc');
if isfield(IMETH,([CallingFunction,'_Data']))
    if isfield(IMETH.([CallingFunction,'_Data']),('QVecSLVfunc_Data'))
        GQNTipt.QVecSlvfunc_Data = IMETHipt.([CallingFunction,'_Data']).QVecSlvfunc_Data;
    end
end
GSRAipt = IMETHipt.('GSRAfunc');
if isfield(IMETH,([CallingFunction,'_Data']))
    if isfield(IMETH.([CallingFunction,'_Data']),('GSRAfunc_Data'))
        GSRAipt.GSRAfunc_Data = IMETHipt.([CallingFunction,'_Data']).GSRAfunc_Data;
    end
end
GSRIipt = IMETHipt.('GSRIfunc');
if isfield(IMETH,([CallingFunction,'_Data']))
    if isfield(IMETH.([CallingFunction,'_Data']),('GSRIfunc_Data'))
        GSRIipt.GSRIfunc_Data = IMETHipt.([CallingFunction,'_Data']).GSRIfunc_Data;
    end
end
KSMPipt = IMETHipt.('kSampfunc');
if isfield(IMETH,([CallingFunction,'_Data']))
    if isfield(IMETH.([CallingFunction,'_Data']),('kSampfunc_Data'))
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
func = str2func(IMETH.gsrafunc);           
[SCRPTipt,GSRA,err] = func(SCRPTipt,GSRAipt);
if err.flag
    return
end
func = str2func(IMETH.gsrifunc);           
[SCRPTipt,GSRI,err] = func(SCRPTipt,GSRIipt);
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
IMETH.ORNT = ORNT;
IMETH.TCPLT = TCPLT;
IMETH.GQNT = GQNT;
IMETH.GSRA = GSRA;
IMETH.GSRI = GSRI;
IMETH.KSMP = KSMP;
IMETH.SR = IMETHipt.([CallingLabel,'_Data']).('StepResp_File_Data').SR;

Status2('done','',2);
Status2('done','',3);