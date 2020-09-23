%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = SelectExcelFileDef(SCRPTipt,SCRPTGBL)

INPUT.Extension = '*.xlsx*';
INPUT.CurFunc = 'SelectExcelFileCur';
[SCRPTipt,SCRPTGBL,saveData,err] = SelectGeneralFileDef_v5(SCRPTipt,SCRPTGBL,INPUT);

