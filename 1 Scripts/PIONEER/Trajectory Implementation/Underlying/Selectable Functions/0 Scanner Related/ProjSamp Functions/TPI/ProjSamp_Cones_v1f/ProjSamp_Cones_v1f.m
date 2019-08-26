%====================================================
% (v1f)
%       - Add possibility to ignore undersampling
%====================================================

function [SCRPTipt,PSMP,err] = ProjSamp_Cones_v1f(SCRPTipt,PSMPipt)

Status2('busy','Get Info for Projection Sampling',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
PSMP.method = PSMPipt.Func;
PSMP.ignoreusamp = PSMPipt.('Ignore_USamp');
PSMP.PCDfunc = PSMPipt.('ProjConeDistfunc').Func;
PSMP.PADfunc = PSMPipt.('ProjAngleDistfunc').Func;

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
CallingFunction = PSMPipt.Struct.labelstr;
PCDipt = PSMPipt.('ProjConeDistfunc');
if isfield(PSMP,([CallingFunction,'_Data']))
    if isfield(PSMP.([CallingFunction,'_Data']),('ProjConeDistfunc_Data'))
        PCDipt.ProjConeDistfunc_Data = PSMPipt.([CallingFunction,'_Data']).ProjConeDistfunc_Data;
    end
end
PADipt = PSMPipt.('ProjAngleDistfunc');
if isfield(PSMP,([CallingFunction,'_Data']))
    if isfield(PSMP.([CallingFunction,'_Data']),('ProjAngleDistfunc_Data'))
        PADipt.ProjAngleDistfunc_Data = PSMPipt.([CallingFunction,'_Data']).ProjAngleDistfunc_Data;
    end
end

%------------------------------------------
% Get PCD Function Info
%------------------------------------------
func = str2func(PSMP.PCDfunc);           
[SCRPTipt,PCD,err] = func(SCRPTipt,PCDipt);
if err.flag
    return
end

%------------------------------------------
% Get PAD Function Info
%------------------------------------------
func = str2func(PSMP.PADfunc);           
[SCRPTipt,PAD,err] = func(SCRPTipt,PADipt);
if err.flag
    return
end

%------------------------------------------
% Return
%------------------------------------------
PSMP.PCD = PCD;
PSMP.PAD = PAD;

Status2('done','',2);
Status2('done','',3);

