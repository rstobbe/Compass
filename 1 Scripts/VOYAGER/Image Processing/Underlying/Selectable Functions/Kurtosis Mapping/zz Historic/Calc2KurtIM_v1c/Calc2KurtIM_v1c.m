%=========================================================
% (Calc2)
%       - direction averaging
% (v1c) 
%       - moved down to underlying function
%=========================================================

function [SCRPTipt,CALC,err] = Calc2KurtIM_v1c(SCRPTipt,CALCipt)

Status2('done','Get Kurtosis Calulation Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
CALC = struct();

%---------------------------------------------
% Return Input
%---------------------------------------------
CALC.constrain = CALCipt.('Constrain');
CALC.minvalonb0 = str2double(CALCipt.('MinVal_b0'));

Status2('done','',2);
Status2('done','',3);
