%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = SelectSiemensDataCurStitchIt(SCRPTipt,SCRPTGBL)

INPUT.Extension = '.dat';
INPUT.CurFunc = 'SelectSiemensDataCurStitchIt';
INPUT.DropExt = 'Yes';
INPUT.Type = 'Data';
INPUT.AssignPath = 'Yes';
[SCRPTipt,SCRPTGBL,saveData,err] = SelectGeneralFileCur_v5(SCRPTipt,SCRPTGBL,INPUT);

if not(isempty(saveData))
    [SCRPTipt,SCRPTGBL,err] = SelectSiemensDataExpStitchIt(SCRPTipt,SCRPTGBL,saveData);
end
