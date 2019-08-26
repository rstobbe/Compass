%====================================================
% (v1a)
%   
%====================================================

function [SCRPTipt,GENPRJ,err] = GenProj_YarnBall_v1a(SCRPTipt,GENPRJipt)

Status2('busy','Get GenProj Function',3);

err.flag = 0;
err.msg = '';

GENPRJ.method = GENPRJipt.Func;   

Status2('done','',3);