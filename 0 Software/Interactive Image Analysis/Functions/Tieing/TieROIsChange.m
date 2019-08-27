%===================================================
%
%===================================================
function TieROIsChange(src,event)

global IMAGEANLZ

currentax = gca;
tab = src.Parent.Parent.Parent.Tag;
axnum = str2double(src.Tag);
SetFocus(tab,axnum);

for n = 1:IMAGEANLZ.(tab)(axnum).axeslen
    IMAGEANLZ.(tab)(n).TieRois(src.Value);
end

if src.Value == 1
    otherax = 0;
    for r = 1:IMAGEANLZ.(tab)(axnum).axeslen
        if r ~= axnum
            if IMAGEANLZ.(tab)(r).TestAxisActive;
                otherax = r;
                break
            end
        end
    end 
    if otherax == 0
        return
    end
    IMAGEANLZ.(tab)(axnum).CopySavedRois(IMAGEANLZ.(tab)(otherax));
    Slice_Change(currentax,tab,axnum,0);
    IMAGEANLZ.(tab)(axnum).ComputeAllSavedROIs;
    IMAGEANLZ.(tab)(axnum).SetSavedROIValues;
end





