%====================================================
% (v00)  
%     - Comparison to Old Only
%====================================================

function [SCRPTipt,SOLFINTEST,err] = SolFineTest_YarnBallCompPrev_v00(SCRPTipt,SOLFINTESTipt) 

Status2('busy','Solution Fineness Testing',3);

err.flag = 0;
err.msg = '';

SOLFINTEST.method = SOLFINTESTipt.Func;

Status2('done','',3);










