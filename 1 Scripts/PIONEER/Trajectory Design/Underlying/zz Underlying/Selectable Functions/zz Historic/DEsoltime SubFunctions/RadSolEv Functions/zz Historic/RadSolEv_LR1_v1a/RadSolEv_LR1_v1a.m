%====================================================
%
%====================================================

function [SCRPTipt,RADEV,err] = RSE_design_v1a(SCRPTipt,RADEVipt)

Status2('done','Get Radial evolution function info',3);

err.flag = 0;
err.msg = '';

RADEV.method = RADEVipt.Func;   

Status2('done','',3);