%=========================================================
% 
%=========================================================

function [SCRPTipt,SCRPTGBL,err] = SelectFidDataCur(SCRPTipt,SCRPTGBL)

INPUT.Extension = '*.*';
INPUT.CurFunc = 'SelectFidDataCur';
[SCRPTipt,SCRPTGBL,saveData,err] = SelectGeneralFileCur_v5(SCRPTipt,SCRPTGBL,INPUT);

if not(isempty(saveData))
    tab = SCRPTGBL.RWSUI.tab;
    if exist([saveData.path,'params'],'file')
        DisplayParamsVarian_v1([saveData.path,'params'],tab);
    end
end