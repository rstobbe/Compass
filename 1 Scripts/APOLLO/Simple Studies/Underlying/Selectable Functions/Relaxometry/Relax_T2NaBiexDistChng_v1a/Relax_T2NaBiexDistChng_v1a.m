%=========================================================
% (v1a) 
%      
%=========================================================

function [SCRPTipt,ANLZ,err] = Relax_T2NaBiexDistChng_v1a(SCRPTipt,ANLZipt)

Status2('busy','T2 Regression',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
ANLZ.method = ANLZipt.Func;

Status2('done','',2);
Status2('done','',3);
