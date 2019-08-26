%====================================================
%  
%====================================================

function DeleteAutoReconGlobal(pos)

global TOTALGBL

val = length(TOTALGBL(1,:));
if strcmp(pos,'end')
    deletenum = val;
elseif strcmp(pos,'prev')
    deletenum = val-1;
end

Delete_TOTALGBL(deletenum);