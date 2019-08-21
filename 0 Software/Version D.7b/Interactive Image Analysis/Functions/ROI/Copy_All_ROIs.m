%============================================
% Copy_All_ROIs
%============================================
function Copy_All_ROIs(tab0,axnum0,tab1,axnum1)

global IMAGEANLZ

if strcmp(IMAGEANLZ.(tab0)(axnum0).MOVEFUNCTION,'buildroi')
    error;          % shouldn't get here
end
if strcmp(IMAGEANLZ.(tab1)(axnum1).MOVEFUNCTION,'buildroi')
    error;          % shouldn't get here
end

for n = 1:length(IMAGEANLZ.(tab0)(axnum0).SAVEDXLOC)
    Copy_ROI(tab0,axnum0,n,tab1,axnum1,n);
end

