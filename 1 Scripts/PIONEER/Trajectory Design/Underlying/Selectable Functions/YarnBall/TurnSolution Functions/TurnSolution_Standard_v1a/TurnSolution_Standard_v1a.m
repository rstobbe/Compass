%====================================================
% (v1a)
%   
%====================================================

function [SCRPTipt,TURN,err] = TurnAround_Erf_v1a(SCRPTipt,TURNipt)

Status2('busy','Get Turn Around Function',3);

err.flag = 0;
err.msg = '';

TURN.method = TURNipt.Func;   

Status2('done','',3);