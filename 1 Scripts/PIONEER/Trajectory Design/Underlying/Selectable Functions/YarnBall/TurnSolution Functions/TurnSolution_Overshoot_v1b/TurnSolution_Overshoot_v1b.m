%====================================================
% (v1b)
%       - include MaxRadDeriv
%====================================================

function [SCRPTipt,TURNSOL,err] = TurnSolution_Overshoot_v1b(SCRPTipt,TURNSOLipt)

Status2('busy','Turn Solution Function',3);

err.flag = 0;
err.msg = '';

TURNSOL.method = TURNSOLipt.Func;   
TURNSOL.endrad = str2double(TURNSOLipt.('RelativeOvershoot'));
TURNSOL.turnloc = str2double(TURNSOLipt.('TurnStart'));
TURNSOL.maxradderivative = str2double(TURNSOLipt.('MaxRadDerivative'));

Status2('done','',3);