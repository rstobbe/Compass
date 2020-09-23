%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = SelectFidDataDef(SCRPTipt,SCRPTGBL)

INPUT.Extension = '*.*';
INPUT.CurFunc = 'SelectFidDataCur';
INPUT.LoadLoc = 'experimentsloc';
[SCRPTipt,SCRPTGBL,saveData,err] = SelectGeneralFileDef_v5(SCRPTipt,SCRPTGBL,INPUT);

tab = SCRPTGBL.RWSUI.tab;
if exist([saveData.path,'params'],'file')
    DisplayParamsVarian_v1([saveData.path,'params'],tab);
end