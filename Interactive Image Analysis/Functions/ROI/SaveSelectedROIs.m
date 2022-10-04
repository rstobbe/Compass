%===================================================
% 
%===================================================
function SaveSelectedROIs(tab,axnum,roinum)

global IMAGEANLZ
global SCRPTPATHS

if not(isempty(IMAGEANLZ.(tab)(axnum).movefunction))
    error;          % shouldn't get here
end

roisloc = SCRPTPATHS.(tab)(1).roisloc;

path = uigetdir(roisloc,'Save ROI');
if path == 0
    return;
end
SCRPTPATHS.(tab)(1).roisloc = path;

for roinum = 1:length(IMAGEANLZ.(tab)(axnum).SAVEDROIS)

    if ~IMAGEANLZ.(tab)(axnum).ROISOFINTEREST(roinum)
        continue
    end
    
    roiname = ['ROI_',IMAGEANLZ.(tab)(axnum).SAVEDROIS(roinum).roiname];
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

    ROI = IMAGEANLZ.(tab)(axnum).SAVEDROIS(roinum);
    save([path,'\',roiname],'ROI');    
end





