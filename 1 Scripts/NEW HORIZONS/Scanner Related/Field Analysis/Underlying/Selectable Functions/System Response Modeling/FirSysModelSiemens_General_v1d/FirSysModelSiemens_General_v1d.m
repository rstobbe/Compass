%=========================================================
% (v1d)
%       - as 'FirSysModelSiemens_BP15141501_v1d'
%=========================================================

function [SCRPTipt,MOD,err] = FirSysModelSiemens_General_v1d(SCRPTipt,MODipt)

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
MOD.mingradinreg = str2double(MODipt.('MinGradInReg'));
MOD.maxgradinreg = str2double(MODipt.('MaxGradInReg'));

Status2('done','',2);
Status2('done','',3);
