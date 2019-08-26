%====================================================
% (v1a)  
%====================================================

function [SCRPTipt,SOLFINTEST,err] = SolFinTest_YarnBall_v1a(SCRPTipt,SOLFINTEST,ipt) 

Status2('busy','Solution Fineness Testing',3);

err.flag = 0;
err.msg = '';

SOLFINTEST.method = SOLFINTESTipt.Func;

Status2('done','',3);










