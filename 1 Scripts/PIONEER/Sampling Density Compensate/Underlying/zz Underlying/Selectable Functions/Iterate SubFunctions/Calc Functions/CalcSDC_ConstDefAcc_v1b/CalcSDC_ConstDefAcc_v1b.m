%==================================================
% (v1b)
%   - update positive normalize
%==================================================

function [SCRPTipt,CALC,err] = CalcSDC_ConstDefAcc_v1b(SCRPTipt,CALCipt)

Status2('busy','Get SDC Calculation Info',2);
Status2('done','',3);

err.flag = 0;
err.mgs = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
CALC.maxrelchange = str2double(CALCipt.('MaxRelChange'));
CALC.acc = str2double(CALCipt.('Acc'));