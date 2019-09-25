%====================================================
% (v1a)
%       
%====================================================

function [SCRPTipt,OPT,err] = Options_OldInovaTpi_v1a(SCRPTipt,OPTipt)

Status2('done','Get Initial Estimate Function Input',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
OPT.method = OPTipt.Func;

Status2('done','',2);
Status2('done','',3);