%====================================================
%
%====================================================

function Save_Global(RWSUI,CellArray,tab)

error();            % just use Load_TOTALGBL...

saveData = RWSUI.SaveVariables{1};
saveData.saveSCRPTcellarray = CellArray(RWSUI.scrptnum,:);
%RWSUI.SaveVariables{1} = output;
totalgbl = [RWSUI.SaveGlobalNames;{saveData}];

Load_TOTALGBL(totalgbl,tab);







