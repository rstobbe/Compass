%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,NMR,err] = ArbitraryT1_v1a(SCRPTipt,NMRipt)

Status2('busy','Arbitrary T1 value',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Get Input
%------------------------------------------
NMR.method = NMRipt.Func;
NMR.ArbT1 = str2double(NMRipt.('T1'));

Status2('done','',2);
Status2('done','',3);

