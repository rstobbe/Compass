%==================================================
% (v1a)
%   -
%==================================================

function [SCRPTipt,CALC,err] = CalcSDC01_v1a(SCRPTipt,CALCipt)

Status2('busy','Get SDC Calculation Info',2);
Status2('done','',3);

err.flag = 0;
err.mgs = '';

CALC = struct();