%====================================================
%
%====================================================

function [SCRPTipt,RADEV,err] = RE_a200b110c10(SCRPTipt,RADEVipt)

Status2('done','Get Radial evolution function info',3);

err.flag = 0;
err.msg = '';

RADEV = struct();    % no panel input

Status2('done','',3);