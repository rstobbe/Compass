%=========================================================
% (v1d)
%       - add figure saving
%=========================================================

function [SCRPTipt,MOD,err] = FirSysModelSiemens_BP30301501_v1d(SCRPTipt,MODipt)

Status2('busy','Regress FIR System Model',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Get Input
%------------------------------------------
MOD.method = MODipt.Func;
MOD.filtlen = str2double(MODipt.('FilterLength'));
MOD.delaygradient = str2double(MODipt.('DelayGradient'));

Status2('done','',2);
Status2('done','',3);
