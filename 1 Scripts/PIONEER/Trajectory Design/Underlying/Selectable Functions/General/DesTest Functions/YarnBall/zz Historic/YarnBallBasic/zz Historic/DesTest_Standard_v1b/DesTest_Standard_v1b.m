%====================================================
% (v1b)
%   
%====================================================

function [SCRPTipt,TST,err] = DesTest_Standard_v1b(SCRPTipt,TSTipt)

Status2('busy','DesignTest',3);

err.flag = 0;
err.msg = '';

TST.method = TSTipt.Func;   

Status2('done','',3);