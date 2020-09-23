%====================================================
%
%====================================================

function File2Global(saveData,saveGlobalNames,saveSCRPTcellarray,tab)

names = fieldnames(saveData);
for n = 1:length(names)
    fields{n} = saveData.(names{n});
end

totalgbl = [saveGlobalNames;fields];

totalgbl{2,1}.saveSCRPTcellarray = saveSCRPTcellarray;
Load_TOTALGBL(totalgbl,tab);

