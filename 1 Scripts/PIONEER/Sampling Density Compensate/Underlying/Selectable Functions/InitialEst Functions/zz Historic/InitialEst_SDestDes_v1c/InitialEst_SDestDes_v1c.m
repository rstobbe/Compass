%====================================================
% (v1c)
%       - update for RWSUI_BA
%====================================================

function [SCRPTipt,IE,err] = InitialEst_SDestDes_v1c(SCRPTipt,IEipt)

Status2('done','Get Initial Estimate Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
IE.script = IEipt.Func;

Status2('done','',2);
Status2('done','',3);