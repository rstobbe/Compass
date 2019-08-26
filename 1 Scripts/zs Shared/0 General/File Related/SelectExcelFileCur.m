%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = SelectExcelFileCur(SCRPTipt,SCRPTGBL)

INPUT.Extension = '*.xlsx*';
INPUT.CurFunc = 'SelectExcelFileCur';
INPUT.Type = 'Excel';
[SCRPTipt,SCRPTGBL,saveData,err] = SelectGeneralFileCur_v5(SCRPTipt,SCRPTGBL,INPUT);
