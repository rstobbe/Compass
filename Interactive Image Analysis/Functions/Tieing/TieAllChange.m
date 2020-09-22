%===================================================
%
%===================================================
function TieAllChange(src,event)

global IMAGEANLZ

currentax = gca;
tab = src.Parent.Parent.Parent.Tag;
axnum = str2double(src.Tag);
SetFocus(tab,axnum);

allow = 1;
dimsallow = 1;
curimsize = IMAGEANLZ.(tab)(axnum).GetBaseImageSize([]);
for r = 1:IMAGEANLZ.(tab)(axnum).axeslen
    if not(IMAGEANLZ.(tab)(r).TestAxisActive)
        continue
    end 
    if axnum ~= r
        othersize = IMAGEANLZ.(tab)(r).GetBaseImageSize([]);
        for n = 1:3
            if curimsize(n) ~= othersize(n)
                allow = 0;
            end
        end
        for n = 4:6
            if curimsize(n) ~= othersize(n)
                dimsallow = 0;
            end
        end
        if not(strcmp(IMAGEANLZ.(tab)(axnum).ORIENT,IMAGEANLZ.(tab)(r).ORIENT))
            allow = 0;
        end
    end
end 

if allow == 0 
    src.Value = 0;
    return
end

for n = 1:IMAGEANLZ.(tab)(axnum).axeslen
    IMAGEANLZ.(tab)(n).TieAll(src.Value);
    if dimsallow == 0 
        IMAGEANLZ.(tab)(n).UnTieDims;
    end
end

if src.Value == 1
    otherax = 0;
    for r = 1:IMAGEANLZ.(tab)(axnum).axeslen
        if r ~= axnum
            if IMAGEANLZ.(tab)(r).TestAxisActive
                otherax = r;
                break
            end
        end
    end 
    if otherax == 0
        return
    end
    IMAGEANLZ.(tab)(axnum).CopySlice(IMAGEANLZ.(tab)(otherax));    
    IMAGEANLZ.(tab)(axnum).CopyScale(IMAGEANLZ.(tab)(otherax));
    IMAGEANLZ.(tab)(axnum).CopySavedRois(IMAGEANLZ.(tab)(otherax));
    Slice_Change(currentax,tab,axnum,0);
    IMAGEANLZ.(tab)(axnum).ComputeAllSavedROIs;
    IMAGEANLZ.(tab)(axnum).SetSavedROIValues;
end




