%====================================================
% (v1a)
%   
%====================================================

function [SCRPTipt,TURN,err] = TurnEvolution_MultiExp1_v1a(SCRPTipt,TURNipt)

Status2('busy','Turn Evolution',3);

err.flag = 0;
err.msg = '';

TURN.method = TURNipt.Func;

Status2('done','',3);