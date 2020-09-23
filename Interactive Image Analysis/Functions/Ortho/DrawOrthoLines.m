%===================================================
%
%===================================================
function DrawOrthoLines(tab)

global IMAGEANLZ

for axnum = 1:IMAGEANLZ.(tab)(1).axeslen;
    if axnum == 1
        InputOrient = {IMAGEANLZ.(tab)(2).ORIENT,IMAGEANLZ.(tab)(3).ORIENT};
        InputSlice = [IMAGEANLZ.(tab)(2).SLICE,IMAGEANLZ.(tab)(3).SLICE];
    elseif axnum == 2
        InputOrient = {IMAGEANLZ.(tab)(1).ORIENT,IMAGEANLZ.(tab)(3).ORIENT};
        InputSlice = [IMAGEANLZ.(tab)(1).SLICE,IMAGEANLZ.(tab)(3).SLICE];
    elseif axnum == 3
        InputOrient = {IMAGEANLZ.(tab)(1).ORIENT,IMAGEANLZ.(tab)(2).ORIENT};
        InputSlice = [IMAGEANLZ.(tab)(1).SLICE,IMAGEANLZ.(tab)(2).SLICE];
    end
    if IMAGEANLZ.(tab)(axnum).TestAxisActive
        if IMAGEANLZ.(tab)(axnum).showortholine
            IMAGEANLZ.(tab)(axnum).DrawOrthoLine(InputOrient,InputSlice);
        else
            IMAGEANLZ.(tab)(axnum).DeleteOrthoLine;
        end
    end
end


