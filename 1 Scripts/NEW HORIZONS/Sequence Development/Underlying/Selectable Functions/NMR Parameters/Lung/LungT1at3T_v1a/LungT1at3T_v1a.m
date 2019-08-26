%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,NMR,err] = LungT1at3T_v1a(SCRPTipt,NMRipt)

Status2('busy','Grey & White T1 values',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Get Input
%------------------------------------------
NMR.method = NMRipt.Func;
NMR.LungT1 = str2double(NMRipt.('LungT1'));

Status2('done','',2);
Status2('done','',3);

