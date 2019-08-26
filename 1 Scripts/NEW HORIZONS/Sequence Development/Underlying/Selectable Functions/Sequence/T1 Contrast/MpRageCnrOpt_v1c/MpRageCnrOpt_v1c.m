%=========================================================
% (v1b)
%   - include TiDel in optimization
%=========================================================

function [SCRPTipt,TST,err] = MpRageCnrOpt_v1c(SCRPTipt,TSTipt)

Status2('busy','MpRage Optization for Cnr',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%------------------------------------------
% Get Input
%------------------------------------------
TST.method = TSTipt.Func;
TST.nonacqtime = str2double(TSTipt.('NonAcqTime'));
TST.slices = str2double(TSTipt.('Slices'));
TST.TiDelMin = str2double(TSTipt.('TiDelMin'));
TST.TrDel = str2double(TSTipt.('TrDel'));
TST.mintr = str2double(TSTipt.('MinTR'));
TST.maxtr = str2double(TSTipt.('MaxTR'));

Status2('done','',2);
Status2('done','',3);

