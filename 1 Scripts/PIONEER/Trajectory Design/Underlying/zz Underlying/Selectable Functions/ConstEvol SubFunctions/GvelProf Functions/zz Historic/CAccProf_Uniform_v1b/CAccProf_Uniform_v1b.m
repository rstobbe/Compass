%====================================================
% (v1b)
%       - update for RWSUI_BA
%====================================================

function [SCRPTipt,CACCP,err] = CAccProf_Uniform_v1b(SCRPTipt,CACCPipt)

Status2('done','Get Acceleration Profile info',3);

err.flag = 0;
err.msg = '';

CACCP = struct();    % no panel input

Status2('done','',3);