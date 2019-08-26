%==================================================
%  (v1a)
%          
%==================================================

function [SCRPTipt,CACCM,err] = CAccMeth3a_v1a(SCRPTipt,CACCMipt)

Status2('done','Get Acceleration Constraint info',3);

err.flag = 0;
err.msg = '';

CACCM = struct();    % no panel input

Status2('done','',3);