%====================================================
% (v1b)
%       - Include CUDA code selection   
%====================================================

function [SCRPTipt,OPT,err] = Options_OldInovaTpi_v1b(SCRPTipt,OPTipt)

Status2('done','Options',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
OPT.method = OPTipt.Func;

Status2('done','',2);
Status2('done','',3);