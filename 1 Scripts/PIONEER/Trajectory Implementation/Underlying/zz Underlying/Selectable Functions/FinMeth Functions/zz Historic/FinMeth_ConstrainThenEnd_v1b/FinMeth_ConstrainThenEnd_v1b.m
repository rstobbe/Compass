%====================================================
% (v1b) 
%   - fix for short spoilers
%====================================================

function [SCRPTipt,FINMETH,err] = FinMeth_ConstrainThenEnd_v1b(SCRPTipt,FINMETHipt) 

Status2('busy','Finish Trajectory',3);

err.flag = 0;
err.msg = '';

FINMETH.method = FINMETHipt.Func;

Status2('done','',3);










