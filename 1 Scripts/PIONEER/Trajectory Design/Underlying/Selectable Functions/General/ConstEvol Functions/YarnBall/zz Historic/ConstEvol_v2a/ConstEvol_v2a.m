%==================================================
% (v2a)
%       - Include acceleration Contraint Tweak Function
%==================================================

function [SCRPTipt,CACC,err] = ConstEvol_v2a(SCRPTipt,CACCipt)

Status2('busy','Get acceleration constraint info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
CACC = struct();
CACC.caccfunc = CACCipt.('ConstAccfunc').Func;
CACC.caccproffunc = CACCipt.('ConstAccProf').Func;
CACC.cacctwkfunc = CACCipt.('ConstAccTwk').Func;
CACC.cjerkfunc = CACCipt.('ConstJerkfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CACCMipt = CACCipt.('ConstAccfunc');
if isfield(CACCipt,('ConstAccfunc_Data'))
    CACCMipt.ConstAccfunc_Data = CACCipt.ConstAccfunc_Data;
end
CACCPipt = CACCipt.('ConstAccProf');
if isfield(CACCipt,('ConstAccProf_Data'))
    CACCPipt.ConstAccProf_Data = CACCipt.ConstAccProf_Data;
end
CACCTipt = CACCipt.('ConstAccTwk');
if isfield(CACCipt,('ConstAccTwk_Data'))
    CACCTipt.ConstAccTwk_Data = CACCipt.ConstAccTwk_Data;
end
CACCJipt = CACCipt.('ConstJerkfunc');
if isfield(CACCipt,('ConstJerkfunc_Data'))
    CACCJipt.ConstJerkfunc_Data = CACCipt.ConstJerkfunc_Data;
end

%------------------------------------------
% Get Sub Function Info
%------------------------------------------
func = str2func(CACC.caccfunc);           
[SCRPTipt,CACCM,err] = func(SCRPTipt,CACCMipt);
if err.flag
    return
end
func = str2func(CACC.caccproffunc);           
[SCRPTipt,CACCP,err] = func(SCRPTipt,CACCPipt);
if err.flag
    return
end
func = str2func(CACC.cacctwkfunc);           
[SCRPTipt,CACCT,err] = func(SCRPTipt,CACCTipt);
if err.flag
    return
end
func = str2func(CACC.cjerkfunc);           
[SCRPTipt,CACCJ,err] = func(SCRPTipt,CACCJipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
CACC.CACCM = CACCM;
CACC.CACCP = CACCP;
CACC.CACCT = CACCT;
CACC.CACCJ = CACCJ;

Status2('done','',2);
Status2('done','',3);

