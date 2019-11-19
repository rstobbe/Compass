%====================================================
% (v2b)
%     - Add Figure Saving
%====================================================

function [SCRPTipt,TF,err] = RFPreGrad_v2b(SCRPTipt,TFipt)

Status2('busy','Get Transient Field Calculation Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
TF.method = TFipt.Func;

Status2('done','',2);
Status2('done','',3);
