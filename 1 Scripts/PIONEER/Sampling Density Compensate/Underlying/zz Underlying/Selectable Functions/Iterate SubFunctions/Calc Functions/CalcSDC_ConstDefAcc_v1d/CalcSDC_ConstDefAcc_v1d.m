%==================================================
% (v1d)
%   - outer change 'slower' than inner
%==================================================

function [SCRPTipt,CALC,err] = CalcSDC_ConstDefAcc_v1d(SCRPTipt,CALCipt)

Status2('busy','Get SDC Calculation Info',2);
Status2('done','',3);

err.flag = 0;
err.mgs = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
CALC.maxrelchange = str2double(CALCipt.('MaxRelChangeEnd'));
CALC.acc = str2double(CALCipt.('Acc'));