%==================================================
%  (v1b)
%       - Update for RWSUI_BA   
%==================================================

function [SCRPTipt,CACCM,err] = CAccMeth_v1b(SCRPTipt,CACCMipt)

Status2('done','Get Acceleration Constraint info',3);

err.flag = 0;
err.msg = '';

CACCM = struct();    % no panel input

Status2('done','',3);