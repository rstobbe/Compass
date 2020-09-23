%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = SelectGenericFileCur(SCRPTipt,SCRPTGBL)

INPUT.Extension = '*.*';
INPUT.CurFunc = 'SelectGenericFileCur';
INPUT.AssignPath = 'Yes';
INPUT.Type = 'Generic';

[SCRPTipt,SCRPTGBL,saveData,err] = SelectGeneralFileCur_v5(SCRPTipt,SCRPTGBL,INPUT);
