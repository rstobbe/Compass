%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LoadSiemensDataCur(SCRPTipt,SCRPTGBL)

INPUT.Extension = '.dat';
INPUT.CurFunc = 'LoadSiemensDataCur';
INPUT.DropExt = 'Yes';
INPUT.Type = 'ScanData';
INPUT.AssignPath = 'Yes';
[SCRPTipt,SCRPTGBL,saveData,err] = SelectGeneralFileCur_v5(SCRPTipt,SCRPTGBL,INPUT);

if not(isempty(saveData))
    [SCRPTipt,SCRPTGBL,err] = LoadSiemensDataExp(SCRPTipt,SCRPTGBL,saveData);
end
