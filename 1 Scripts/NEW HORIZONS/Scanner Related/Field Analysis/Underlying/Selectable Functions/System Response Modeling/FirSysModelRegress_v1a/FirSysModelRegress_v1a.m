%=========================================================
% (v1a)
%      
%=========================================================

function [SCRPTipt,MOD,err] = FirSysModelRegress_v1a(SCRPTipt,MODipt)

Status2('busy','Regress FIR System Model',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Get Input
%------------------------------------------
MOD.method = MODipt.Func;
MOD.subrgrslen = MODipt.('SubRrgsLen');
MOD.graddel = str2double(MODipt.('GradientDelay'));

Status2('done','',2);
Status2('done','',3);
