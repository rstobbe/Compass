%====================================================
% (v1c)
%   - rSNR value change
%====================================================

function [SCRPTipt,TST,err] = DesTest_TpiGslew_v1c(SCRPTipt,TSTipt)

Status2('busy','DesignTest',3);

err.flag = 0;
err.msg = '';

TST.method = TSTipt.Func;   
TST.nuc = TSTipt.('Nucleus');

Status2('done','',3);