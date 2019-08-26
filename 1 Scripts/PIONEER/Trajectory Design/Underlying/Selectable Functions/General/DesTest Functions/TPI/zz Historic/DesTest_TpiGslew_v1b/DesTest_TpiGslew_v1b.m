%====================================================
% (v1b)
%   - add gamma selection
%====================================================

function [SCRPTipt,TST,err] = DesTest_TpiGslew_v1b(SCRPTipt,TSTipt)

Status2('busy','DesignTest',3);

err.flag = 0;
err.msg = '';

TST.method = TSTipt.Func;   
TST.nuc = TSTipt.('Nucleus');

Status2('done','',3);