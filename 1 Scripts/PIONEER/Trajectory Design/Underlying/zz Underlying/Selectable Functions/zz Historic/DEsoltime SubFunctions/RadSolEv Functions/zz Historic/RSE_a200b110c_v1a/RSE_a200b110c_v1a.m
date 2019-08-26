%====================================================
%
%====================================================

function [SCRPTipt,RADEV,err] = RE_a200b110c(SCRPTipt,RADEVipt)

Status2('done','Get Radial evolution function info',3);

err.flag = 0;
err.msg = '';

RADEV.method = RADEVipt.Func;   
RADEV.retc3 = RADEVipt.('ReTc3');
RADEV.reval3 = RADEVipt.('ReVal3'); 

Status2('done','',3);