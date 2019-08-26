%====================================================
% (v1c)
%   - fix for solving before rad = 1
%====================================================

function [SCRPTipt,TURN,err] = TurnEvolution_Erf_v1c(SCRPTipt,TURNipt)

Status2('busy','Turn Evolution',3);

err.flag = 0;
err.msg = '';

TURN.method = TURNipt.Func;
TURN.start = str2double(TURNipt.('Start'));
TURN.slope = str2double(TURNipt.('Slope'));

Status2('done','',3);