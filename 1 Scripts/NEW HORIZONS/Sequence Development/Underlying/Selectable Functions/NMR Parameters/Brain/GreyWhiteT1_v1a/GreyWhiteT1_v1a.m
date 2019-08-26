%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,NMR,err] = GreyWhiteT1_v1a(SCRPTipt,NMRipt)

Status2('busy','Grey & White T1 values',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Get Input
%------------------------------------------
NMR.method = NMRipt.Func;
NMR.GreyT1 = str2double(NMRipt.('GreyT1'));
NMR.WhiteT1 = str2double(NMRipt.('WhiteT1'));

Status2('done','',2);
Status2('done','',3);

