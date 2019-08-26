%==================================================
% (v3c)
%       - same as ConstEvol_v3c
%==================================================

function [SCRPTipt,CACC,err] = ConstEvol3D_v3c(SCRPTipt,CACCipt)

Status2('busy','Get acceleration constraint info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
CACC.method = CACCipt.Func; 
CACC.caccfunc = CACCipt.('ConstAccfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CACCMipt = CACCipt.('ConstAccfunc');
if isfield(CACCipt,('ConstAccfunc_Data'))
    CACCMipt.ConstAccfunc_Data = CACCipt.ConstAccfunc_Data;
end

%------------------------------------------
% Get Sub Function Info
%------------------------------------------
func = str2func(CACC.caccfunc);           
[SCRPTipt,CACCM,err] = func(SCRPTipt,CACCMipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
CACC.CACCM = CACCM;

Status2('done','',2);
Status2('done','',3);

