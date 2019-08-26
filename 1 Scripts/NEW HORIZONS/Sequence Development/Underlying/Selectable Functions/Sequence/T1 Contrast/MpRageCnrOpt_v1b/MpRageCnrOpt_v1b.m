%=========================================================
% (v1b)
%   - include TIdel and TRdel as inputs
%=========================================================

function [SCRPTipt,TST,err] = MpRageCnrOpt_v1b(SCRPTipt,TSTipt)

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
TST.TIdel = str2double(TSTipt.('TIdel'));
TST.TRdel = str2double(TSTipt.('TRdel'));
TST.mintr = str2double(TSTipt.('MinTR'));
TST.maxtr = str2double(TSTipt.('MaxTR'));

Status2('done','',2);
Status2('done','',3);

