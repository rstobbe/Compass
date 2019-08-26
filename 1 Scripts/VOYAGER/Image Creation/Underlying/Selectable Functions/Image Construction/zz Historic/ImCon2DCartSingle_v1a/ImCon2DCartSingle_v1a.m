%====================================================
% (v1a)
%       
%====================================================

function [SCRPTipt,IC,err] = ImCon2DCartSingle_v1a(SCRPTipt,ICipt)

Status('busy','Create H1 2D Cartesian Image');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
IC.method = ICipt.Func;
IC.preprocfunc = ICipt.('PreProcfunc').Func;
IC.rcvcombfunc = ICipt.('RcvCombfunc').Func;
IC.filterfunc = ICipt.('Filterfunc').Func;
IC.zerofillfunc = ICipt.('ZeroFillfunc').Func;
IC.postprocfunc = ICipt.('PostProcfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingLabel = ICipt.Struct.labelstr;
PREPRCipt = ICipt.('PreProcfunc');
if isfield(ICipt,([CallingLabel,'_Data']))
    if isfield(ICipt.([CallingLabel,'_Data']),'PreProcfunc_Data')
        PREPRCipt.('PreProcfunc_Data') = ICipt.([CallingLabel,'_Data']).('PreProcfunc_Data');
    end
end
RCOMBipt = ICipt.('RcvCombfunc');
if isfield(ICipt,([CallingLabel,'_Data']))
    if isfield(ICipt.([CallingLabel,'_Data']),'RcvCombfunc_Data')
        RCOMBipt.('RcvCombfunc_Data') = ICipt.([CallingLabel,'_Data']).('RcvCombfunc_Data');
    end
end
FILTipt = ICipt.('Filterfunc');
if isfield(ICipt,([CallingLabel,'_Data']))
    if isfield(ICipt.([CallingLabel,'_Data']),'Filterfunc_Data')
        FILTipt.('Filterfunc_Data') = ICipt.([CallingLabel,'_Data']).('Filterfunc_Data');
    end
end
ZFipt = ICipt.('ZeroFillfunc');
if isfield(ICipt,([CallingLabel,'_Data']))
    if isfield(ICipt.([CallingLabel,'_Data']),'ZeroFillfunc_Data')
        FILTipt.('ZeroFillfunc_Data') = ICipt.([CallingLabel,'_Data']).('ZeroFillfunc_Data');
    end
end
PSTPRCipt = ICipt.('PostProcfunc');
if isfield(ICipt,([CallingLabel,'_Data']))
    if isfield(ICipt.([CallingLabel,'_Data']),'PostProcfunc_Data')
        PSTPRCipt.('PostProcfunc_Data') = ICipt.([CallingLabel,'_Data']).('PostProcfunc_Data');
    end
end

%------------------------------------------
% Get Pre Processing Function Info
%------------------------------------------
func = str2func(IC.preprocfunc);           
[SCRPTipt,PREPRC,err] = func(SCRPTipt,PREPRCipt);
if err.flag
    return
end

%------------------------------------------
% Get Receiver Combination Function Info
%------------------------------------------
func = str2func(IC.rcvcombfunc);           
[SCRPTipt,RCOMB,err] = func(SCRPTipt,RCOMBipt);
if err.flag
    return
end

%------------------------------------------
% Get Filter Function Info
%------------------------------------------
func = str2func(IC.filterfunc);           
[SCRPTipt,FILT,err] = func(SCRPTipt,FILTipt);
if err.flag
    return
end

%------------------------------------------
% Get ZeroFill Function Info
%------------------------------------------
func = str2func(IC.zerofillfunc);           
[SCRPTipt,ZF,err] = func(SCRPTipt,ZFipt);
if err.flag
    return
end

%------------------------------------------
% Get Post Processing Function Info
%------------------------------------------
func = str2func(IC.postprocfunc);           
[SCRPTipt,PSTPRC,err] = func(SCRPTipt,PSTPRCipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
IC.PREPRC = PREPRC;
IC.RCOMB = RCOMB;
IC.FILT = FILT;
IC.ZF = ZF;
IC.PSTPRC = PSTPRC;

Status2('done','',2);
Status2('done','',3);




