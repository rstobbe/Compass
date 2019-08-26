%====================================================
% (v1c)
%   - with inputs
%====================================================

function [SCRPTipt,TURN,err] = TurnEvolution_MultiExp1_v1c(SCRPTipt,TURNipt)

Status2('busy','Turn Evolution',3);

err.flag = 0;
err.msg = '';

TURN.method = TURNipt.Func;
TURN.exp1 = str2double(TURNipt.('Exp1'));
TURN.exp2 = str2double(TURNipt.('Exp2'));
TURN.exp3 = str2double(TURNipt.('Exp3'));

Status2('done','',3);