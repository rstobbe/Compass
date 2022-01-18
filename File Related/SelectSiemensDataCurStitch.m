%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = SelectSiemensDataCurStitch(SCRPTipt,SCRPTGBL)

INPUT.Extension = '.dat';
INPUT.CurFunc = 'SelectSiemensDataCurStitch';
INPUT.DropExt = 'Yes';
INPUT.Type = 'TestData';
INPUT.AssignPath = 'Yes';
[SCRPTipt,SCRPTGBL,saveData,err] = SelectGeneralFileCur_v5(SCRPTipt,SCRPTGBL,INPUT);

if not(isempty(saveData))
    [SCRPTipt,SCRPTGBL,err] = SelectSiemensDataExpStitch(SCRPTipt,SCRPTGBL,saveData);
end
