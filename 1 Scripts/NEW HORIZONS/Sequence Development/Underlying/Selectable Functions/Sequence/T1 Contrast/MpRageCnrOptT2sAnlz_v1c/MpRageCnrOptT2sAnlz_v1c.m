%=========================================================
% (v1c)
%   - same as 'MpRageCnrOpt_v1c'
%=========================================================

function [SCRPTipt,TST,err] = MpRageCnrOptT2sAnlz_v1c(SCRPTipt,TSTipt)

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
TST.T2star = str2double(TSTipt.('T2star'));
TST.TrDel = str2double(TSTipt.('TrDel'));
TST.mintr = str2double(TSTipt.('MinTR'));
TST.maxtr = str2double(TSTipt.('MaxTR'));

Status2('done','',2);
Status2('done','',3);

