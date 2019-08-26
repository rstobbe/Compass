%====================================================
% (v1g)
%       - add global sampling density stuff from IMP
%====================================================

function [SCRPTipt,IE,err] = InitialEst_SDestDesSphere_v1g(SCRPTipt,IEipt)

Status2('done','Get Initial Estimate Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
IE.script = IEipt.Func;
IE.smoothing = str2double(IEipt.('Smoothing'));

Status2('done','',2);
Status2('done','',3);