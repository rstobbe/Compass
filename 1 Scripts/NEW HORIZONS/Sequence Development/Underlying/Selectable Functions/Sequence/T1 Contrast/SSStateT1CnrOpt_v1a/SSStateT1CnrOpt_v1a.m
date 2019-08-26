%=========================================================
% (v1a)
%
%=========================================================

function [SCRPTipt,TST,err] = SSStateT1CnrOpt_v1a(SCRPTipt,TSTipt)

Status2('busy','CNR optimization',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Get Input
%------------------------------------------
TST.method = TSTipt.Func;
TST.nonacqtime = str2double(TSTipt.('NonAcqTime'));
TST.mintr = str2double(TSTipt.('MinTR'));
TST.maxtr = str2double(TSTipt.('MaxTR'));

Status2('done','',2);
Status2('done','',3);
