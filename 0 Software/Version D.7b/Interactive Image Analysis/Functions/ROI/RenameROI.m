%===================================================
% 
%===================================================
function RenameROI(tab,axnum,roinum)

global IMAGEANLZ

roiname = inputdlg('Enter ROI Name: ','ROI Name',1,{IMAGEANLZ.(tab)(axnum).SAVEDROIS(roinum).roiname});
if isempty(roiname)
    return
end
roiname = roiname{1};

if IMAGEANLZ.(tab)(axnum).ROITIE == 1
    start = 1;    
    stop = IMAGEANLZ.(tab)(axnum).axeslen;
else
    start = axnum;
    stop = axnum;
end

for r = start:stop
    if IMAGEANLZ.(tab)(r).TestAxisActive
        IMAGEANLZ.(tab)(r).SAVEDROIS(roinum).SetROIName(roiname);
        IMAGEANLZ.(tab)(r).SetSavedROIValues;  
    end
end



