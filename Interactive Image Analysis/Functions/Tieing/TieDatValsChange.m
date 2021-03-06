%===================================================
%
%===================================================
function TieDatValsChange(src,event)

global IMAGEANLZ

currentax = gca;
tab = src.Parent.Parent.Parent.Tag;
axnum = str2double(src.Tag);
SetFocus(tab,axnum);

allow = 1;
curimsize = IMAGEANLZ.(tab)(axnum).GetBaseImageSize([]);
for r = 1:IMAGEANLZ.(tab)(axnum).axeslen
    if axnum ~= r
        if not(IMAGEANLZ.(tab)(r).TestAxisActive);
            continue
        end
        othersize = IMAGEANLZ.(tab)(r).GetBaseImageSize([]);
        for n = 1:3
            if curimsize(n) ~= othersize(n)
                allow = 0;
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
    IMAGEANLZ.(tab)(n).TieDatVals(src.Value);
end

if src.Value == 1
    Slice_Change(currentax,tab,axnum,0);
end


