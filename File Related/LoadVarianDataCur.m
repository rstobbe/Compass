%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LoadVarianDataCur(SCRPTipt,SCRPTGBL)

INPUT.Extension = '*.*';
INPUT.CurFunc = 'LoadVarianDataCur';
INPUT.DropExt = 'No';
INPUT.Type = 'ScanData';
INPUT.AssignPath = 'Yes';
[SCRPTipt,SCRPTGBL,saveData,err] = SelectGeneralFileCur_v5(SCRPTipt,SCRPTGBL,INPUT);

if not(isempty(saveData))
    [SCRPTipt,SCRPTGBL,err] = LoadVarianDataExp(SCRPTipt,SCRPTGBL,saveData);
end
