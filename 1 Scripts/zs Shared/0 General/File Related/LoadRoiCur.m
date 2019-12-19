%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = LoadRoiCur(SCRPTipt,SCRPTGBL)

INPUT.Extension = '*.mat*';
INPUT.CurFunc = 'LoadRoiCur';
INPUT.Type = 'Roi';
INPUT.AssignPath = 'Yes';
[SCRPTipt,SCRPTGBL,saveData,err] = SelectGeneralFileCur_v5(SCRPTipt,SCRPTGBL,INPUT);
