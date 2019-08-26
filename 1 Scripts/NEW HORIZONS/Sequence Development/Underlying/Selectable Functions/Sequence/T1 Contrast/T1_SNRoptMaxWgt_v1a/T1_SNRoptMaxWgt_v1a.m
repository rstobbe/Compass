%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,TST,err] = T1_SNRoptMaxWgt_v1a(SCRPTipt,TSTipt)

Status2('busy','SNR optimization',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Get Input
%------------------------------------------
TST.method = TSTipt.Func;
TST.trmark = str2double(TSTipt.('TRmark'));
TST.flipmark = str2double(TSTipt.('Flipmark'));

Status2('done','',2);
Status2('done','',3);

