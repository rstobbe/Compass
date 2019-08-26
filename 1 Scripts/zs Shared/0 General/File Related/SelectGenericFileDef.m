%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = SelectGenericFileDef(SCRPTipt,SCRPTGBL)

INPUT.Extension = '*.*';
INPUT.CurFunc = 'SelectGenericFileCur';
INPUT.Type = 'Generic';

[SCRPTipt,SCRPTGBL,saveData,err] = SelectGeneralFileDef_v5(SCRPTipt,SCRPTGBL,INPUT);

