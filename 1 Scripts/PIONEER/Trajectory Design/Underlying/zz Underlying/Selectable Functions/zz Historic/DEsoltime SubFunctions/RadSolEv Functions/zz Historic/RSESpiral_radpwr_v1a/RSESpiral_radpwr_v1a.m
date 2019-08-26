%====================================================
% (v1c)
%       - more number tweaking
%====================================================

function [SCRPTipt,RADEV,err] = RSE_radpwr_v1c(SCRPTipt,RADEVipt)

Status2('done','Get Radial evolution function info',3);

err.flag = 0;
err.msg = '';

RADEV.method = RADEVipt.Func;   
RADEV.pval = RADEVipt.('RadPwr');

Status2('done','',3);