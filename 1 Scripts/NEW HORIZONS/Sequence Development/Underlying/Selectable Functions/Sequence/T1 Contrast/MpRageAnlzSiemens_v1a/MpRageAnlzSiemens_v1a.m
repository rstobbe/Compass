%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,TST,err] = MpRageAnlzSiemens_v1a(SCRPTipt,TSTipt)

Status2('busy','MpRage Analysis (Siemens Parameters)',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Get Input
%------------------------------------------
TST.method = TSTipt.Func;
TST.TR = str2double(TSTipt.('TR'));
TST.TI = str2double(TSTipt.('TI'));
TST.RelEcho = str2double(TSTipt.('RelativeEcho'));
TST.TurboFactor = str2double(TSTipt.('TurboFactor'));
TST.EchoSpace = str2double(TSTipt.('EchoSpace'));
TST.Flip = str2double(TSTipt.('Flip'));
TST.BW = str2double(TSTipt.('BW'));
TST.TE = str2double(TSTipt.('TE'));

Status2('done','',2);
Status2('done','',3);

