%====================================================
% (v0a)
%       - testing
%====================================================

function [SCRPTipt,CACCP,err] = CAccProf_ExpDecay_v0a(SCRPTipt,CACCPipt)

Status2('done','Get Acceleration Profile info',3);

err.flag = 0;
err.msg = '';

CACCP = struct();    % no panel input

Status2('done','',3);