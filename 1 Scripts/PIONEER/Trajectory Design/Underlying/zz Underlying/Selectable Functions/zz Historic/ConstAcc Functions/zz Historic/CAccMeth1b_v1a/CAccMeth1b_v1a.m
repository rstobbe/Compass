%==================================================
%  (Meth1b)
%       - Includes some smoothing on output
%==================================================

function [SCRPTipt,CACCM,err] = CAccMeth1b_v1a(SCRPTipt,CACCMipt)

Status2('done','Get Acceleration Constraint info',3);

err.flag = 0;
err.msg = '';

CACCM.method = CACCMipt.Func;    

Status2('done','',3);