%==================================================
%  (Meth2)
%       - This method doesn't work
%       - results in timing oscillation
%==================================================

function [SCRPTipt,CACCM,err] = CAccMeth2_v1a(SCRPTipt,CACCMipt)

Status2('done','Get Acceleration Constraint info',3);

err.flag = 0;
err.msg = '';

CACCM = struct();    % no panel input

Status2('done','',3);