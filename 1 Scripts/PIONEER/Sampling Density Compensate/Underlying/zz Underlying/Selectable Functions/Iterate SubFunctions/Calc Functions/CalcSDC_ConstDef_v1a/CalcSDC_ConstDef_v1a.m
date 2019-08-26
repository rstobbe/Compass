%==================================================
% (v1a)
%   -
%==================================================

function [SCRPTipt,CALC,err] = CalcSDC_ConstDef_v1a(SCRPTipt,CALCipt)

Status2('busy','Get SDC Calculation Info',2);
Status2('done','',3);

err.flag = 0;
err.mgs = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
CALC.maxrelchange = str2double(CALCipt.('MaxRelChange'));
