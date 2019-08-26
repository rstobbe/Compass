%====================================================
% (v1a)
%       
%====================================================

function [SCRPTipt,OPT,err] = Options_Standard_v1a(SCRPTipt,OPTipt)

Status2('done','Get Initial Estimate Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
OPT.method = OPTipt.Func;
OPT.precision = OPTipt.('Precision');
OPT.ResetGpus = OPTipt.('ResetGpus');

Status2('done','',2);
Status2('done','',3);