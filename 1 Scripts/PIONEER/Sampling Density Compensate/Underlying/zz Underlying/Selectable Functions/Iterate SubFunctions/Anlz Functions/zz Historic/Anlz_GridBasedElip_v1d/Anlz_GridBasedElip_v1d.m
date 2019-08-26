%==================================================
% (v1d)
%   - update for function splitting
%==================================================

function [SCRPTipt,ANLZ,err] = Anlz_GridBasedElip_v1d(SCRPTipt,ANLZipt)

Status2('busy','Get Anlyze Function Info',2);
Status2('done','',3);

err.flag = 0;
err.mgs = '';

ANLZ = struct();