%====================================================
%
%====================================================

function Save_Global2(saveGlobalNames,saveData,saveSCRPTcellarray,tab)


error();            % just use Load_TOTALGBL...

saveData.saveSCRPTcellarray = saveSCRPTcellarray;
totalgbl = [saveGlobalNames;{saveData}];

Load_TOTALGBL(totalgbl,tab);







