%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = SelectSiemensDataDef(SCRPTipt,SCRPTGBL)

INPUT.Extension = '.dat';
INPUT.CurFunc = 'SelectSiemensDataCur';
INPUT.LoadLoc = 'experimentsloc';
[SCRPTipt,SCRPTGBL,saveData,err] = SelectGeneralFileDef_v5(SCRPTipt,SCRPTGBL,INPUT);

