%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = SelectSiemensDataCur(SCRPTipt,SCRPTGBL)

INPUT.Extension = '.dat';
INPUT.CurFunc = 'SelectSiemensDataCur';
INPUT.DropExt = 'Yes';
INPUT.Type = 'ScanData';
[SCRPTipt,SCRPTGBL,saveData,err] = SelectGeneralFileCur_v5(SCRPTipt,SCRPTGBL,INPUT);

if not(isempty(saveData))
    [SCRPTipt,SCRPTGBL,err] = SelectSiemensDataExp(SCRPTipt,SCRPTGBL,saveData);
end
