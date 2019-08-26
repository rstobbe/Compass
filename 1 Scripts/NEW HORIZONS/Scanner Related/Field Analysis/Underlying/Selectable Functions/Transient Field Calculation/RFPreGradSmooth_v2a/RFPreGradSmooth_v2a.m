%====================================================
% (v2a)
%     - start 'RFPreMultiGrad_v1a'   
%     - Remove Input (now from above)
%====================================================

function [SCRPTipt,TF,err] = RFPreGradSmooth_v2a(SCRPTipt,TFipt)

Status2('busy','Get Transient Field Calculation Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
TF.method = TFipt.Func;
TF.smoothfactor = str2double(TFipt.SmoothFactor);
TF.smoothfraction = str2double(TFipt.SmoothFraction);

Status2('done','',2);
Status2('done','',3);
