%==================================================
%  (v2a)
%       -
%==================================================

function [SCRPTipt,CACC,err] = ConstEvol_ShapeAlongTraj_v2a(SCRPTipt,CACCMipt)

Status2('done','Get Evolution Constraint info',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
CACC.method = CACCMipt.Func;   

Status2('done','',3);