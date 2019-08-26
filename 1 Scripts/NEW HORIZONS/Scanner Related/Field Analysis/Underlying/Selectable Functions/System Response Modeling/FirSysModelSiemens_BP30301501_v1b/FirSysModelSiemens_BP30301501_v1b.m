%=========================================================
% (v1b)
%       - update for filter length input  
%=========================================================

function [SCRPTipt,MOD,err] = FirSysModelSiemens_BP30301501_v1b(SCRPTipt,MODipt)

Status2('busy','Regress FIR System Model',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Get Input
%------------------------------------------
MOD.method = MODipt.Func;
MOD.filtlen = str2double(MODipt.('FilterLength'));

Status2('done','',2);
Status2('done','',3);
