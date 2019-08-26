%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,TST,err] = SSStateT1WgtAnlz_v1a(SCRPTipt,TSTipt)

Status2('busy','CNR Analysis',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Get Input
%------------------------------------------
TST.method = TSTipt.Func;
TST.TR = str2double(TSTipt.('TR'));
TST.Flip = str2double(TSTipt.('Flip'));

Status2('done','',2);
Status2('done','',3);

