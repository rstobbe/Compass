%====================================================
% (v1a)
%   
%====================================================

function [SCRPTipt,TURNSOL,err] = TurnSolution_Overshoot_v1a(SCRPTipt,TURNSOLipt)

Status2('busy','Turn Solution Function',3);

err.flag = 0;
err.msg = '';

TURNSOL.method = TURNSOLipt.Func;   
TURNSOL.endrad = str2double(TURNSOLipt.('RelativeOvershoot'));
TURNSOL.turnloc = str2double(TURNSOLipt.('TurnStart'));

Status2('done','',3);