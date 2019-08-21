%===================================================
% 
%===================================================
function TableAllROIs(tab,axnum)

global IMAGEANLZ
global SCRPTPATHS

if not(isempty(IMAGEANLZ.(tab)(axnum).movefunction))
    error;          % shouldn't get here
end

roisloc = SCRPTPATHS.(tab)(1).roisloc;

for n = 1:length(IMAGEANLZ.(tab)(axnum).SAVEDROIS)
    RoiName{n,1} = IMAGEANLZ.(tab)(axnum).SAVEDROIS(n).roiname;
    Vol(n,1) = IMAGEANLZ.(tab)(axnum).SAVEDROIS(n).roivol;
    Mean(n,1) = IMAGEANLZ.(tab)(axnum).SAVEDROIS(n).roimean;
    Sdv(n,1) = IMAGEANLZ.(tab)(axnum).SAVEDROIS(n).roisdv;
end

T = table(RoiName,Mean,Sdv,Vol)
writetable(T,[roisloc,'TempExcel.xlsx']);


