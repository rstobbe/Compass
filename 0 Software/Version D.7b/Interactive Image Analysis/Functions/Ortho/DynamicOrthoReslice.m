%===================================================
%
%===================================================
function DynamicOrthoReslice(tab,axnum,x,y)

global IMAGEANLZ

if IMAGEANLZ.(tab)(axnum).TestTinyMove;
    return
end
if IMAGEANLZ.(tab)(axnum).TestMouseInImage([round(x),round(y)]) ~= 1
    return
end

imsize = IMAGEANLZ.(tab)(axnum).GetImageSize;

if axnum == 1
    if strcmp(IMAGEANLZ.(tab)(1).ORIENT,'Axial')
        IMAGEANLZ.(tab)(2).SetSlice(round(x));
        IMAGEANLZ.(tab)(3).SetSlice(round(y));
    elseif strcmp(IMAGEANLZ.(tab)(1).ORIENT,'Sagittal')
        IMAGEANLZ.(tab)(3).SetSlice(imsize(1)-round(y)+1);
        IMAGEANLZ.(tab)(2).SetSlice(round(x));
    elseif strcmp(IMAGEANLZ.(tab)(1).ORIENT,'Coronal')
        IMAGEANLZ.(tab)(3).SetSlice(round(x));
        IMAGEANLZ.(tab)(2).SetSlice(imsize(1)-round(y)+1);
    end
    IMAGEANLZ.(tab)(2).SetImageSlice;
    IMAGEANLZ.(tab)(3).SetImageSlice;
    IMAGEANLZ.(tab)(2).PlotImage;
    IMAGEANLZ.(tab)(3).PlotImage;
    arr = [2 3];
elseif axnum == 2
    if strcmp(IMAGEANLZ.(tab)(2).ORIENT,'Axial')
        IMAGEANLZ.(tab)(3).SetSlice(round(x));
        IMAGEANLZ.(tab)(1).SetSlice(round(y));
    elseif strcmp(IMAGEANLZ.(tab)(2).ORIENT,'Sagittal')
        IMAGEANLZ.(tab)(1).SetSlice(imsize(1)-round(y)+1);
        IMAGEANLZ.(tab)(3).SetSlice(round(x));
    elseif strcmp(IMAGEANLZ.(tab)(2).ORIENT,'Coronal')
        IMAGEANLZ.(tab)(1).SetSlice(round(x));
        IMAGEANLZ.(tab)(3).SetSlice(imsize(1)-round(y)+1);
    end
    IMAGEANLZ.(tab)(1).SetImageSlice;
    IMAGEANLZ.(tab)(3).SetImageSlice;
    IMAGEANLZ.(tab)(1).PlotImage;
    IMAGEANLZ.(tab)(3).PlotImage; 
    arr = [1 3];
elseif axnum == 3
    if strcmp(IMAGEANLZ.(tab)(3).ORIENT,'Axial')
        IMAGEANLZ.(tab)(1).SetSlice(round(x));
        IMAGEANLZ.(tab)(2).SetSlice(round(y));
    elseif strcmp(IMAGEANLZ.(tab)(3).ORIENT,'Sagittal')
        IMAGEANLZ.(tab)(2).SetSlice(imsize(1)-round(y)+1);
        IMAGEANLZ.(tab)(1).SetSlice(round(x));
    elseif strcmp(IMAGEANLZ.(tab)(3).ORIENT,'Coronal')
        IMAGEANLZ.(tab)(2).SetSlice(round(x));
        IMAGEANLZ.(tab)(1).SetSlice(imsize(1)-round(y)+1);
    end
    IMAGEANLZ.(tab)(2).SetImageSlice;
    IMAGEANLZ.(tab)(1).SetImageSlice;
    IMAGEANLZ.(tab)(2).PlotImage;
    IMAGEANLZ.(tab)(1).PlotImage;
    arr = [1 2];
end

for r = 1:2
    if IMAGEANLZ.(tab)(arr(r)).SAVEDROISFLAG == 1
        if IMAGEANLZ.(tab)(arr(r)).GETROIS == 1
            IMAGEANLZ.(tab)(arr(r)).DrawSavedROIsNoPick([]);
        else
            IMAGEANLZ.(tab)(arr(r)).DrawSavedROIs([]);
        end
    end
    if IMAGEANLZ.(tab)(arr(r)).GETROIS == 1
        IMAGEANLZ.(tab)(arr(r)).DrawCurrentROI([]);
        IMAGEANLZ.(tab)(arr(r)).DrawTempROI([],[]);
    end
end

DrawOrthoLines(tab);