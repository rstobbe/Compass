%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = SelectSimulationDataCurStitchIt(SCRPTipt,SCRPTGBL)

INPUT.Extension = '.mat';
INPUT.CurFunc = 'SelectSimulationDataCurStitchIt';
INPUT.DropExt = 'Yes';
INPUT.Type = 'Data';
INPUT.AssignPath = 'Yes';
[SCRPTipt,SCRPTGBL,saveData,err] = SelectGeneralFileCur_v5(SCRPTipt,SCRPTGBL,INPUT);

if not(isempty(saveData))
    [SCRPTipt,SCRPTGBL,err] = SelectSimulationDataExpStitchIt(SCRPTipt,SCRPTGBL,saveData);
end
