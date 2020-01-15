%===================================================
%
%===================================================
function UpdateOrthoOrientations(tab,PrevOrient)

global IMAGEANLZ

for n = 1:3
    slice(n) = IMAGEANLZ.(tab)(n).SLICE;
end

if strcmp(IMAGEANLZ.(tab)(1).GetOrient,'Axial')
    IMAGEANLZ.(tab)(2).SetOrient('Sagittal',1);
    IMAGEANLZ.(tab)(3).SetOrient('Coronal',1);
    if strcmp(PrevOrient,'Sagittal')
        IMAGEANLZ.(tab)(1).SetSlice(slice(3));
        IMAGEANLZ.(tab)(2).SetSlice(slice(1));
        IMAGEANLZ.(tab)(3).SetSlice(slice(2));
    elseif strcmp(PrevOrient,'Coronal')
        IMAGEANLZ.(tab)(1).SetSlice(slice(2));
        IMAGEANLZ.(tab)(2).SetSlice(slice(3));
        IMAGEANLZ.(tab)(3).SetSlice(slice(1));
    end    
elseif strcmp(IMAGEANLZ.(tab)(1).GetOrient,'Sagittal')
    IMAGEANLZ.(tab)(2).SetOrient('Coronal',1);
    IMAGEANLZ.(tab)(3).SetOrient('Axial',1);
    if strcmp(PrevOrient,'Axial')
        IMAGEANLZ.(tab)(1).SetSlice(slice(2));
        IMAGEANLZ.(tab)(2).SetSlice(slice(3));
        IMAGEANLZ.(tab)(3).SetSlice(slice(1));
    end  
    if strcmp(PrevOrient,'Coronal')
        IMAGEANLZ.(tab)(1).SetSlice(slice(3));
        IMAGEANLZ.(tab)(2).SetSlice(slice(1));
        IMAGEANLZ.(tab)(3).SetSlice(slice(2));
    end  
elseif strcmp(IMAGEANLZ.(tab)(1).GetOrient,'Coronal')
    IMAGEANLZ.(tab)(2).SetOrient('Axial',1);
    IMAGEANLZ.(tab)(3).SetOrient('Sagittal',1);
    if strcmp(PrevOrient,'Axial')
        IMAGEANLZ.(tab)(1).SetSlice(slice(3));
        IMAGEANLZ.(tab)(2).SetSlice(slice(1));
        IMAGEANLZ.(tab)(3).SetSlice(slice(2));
    elseif strcmp(PrevOrient,'Sagittal')
        IMAGEANLZ.(tab)(1).SetSlice(slice(2));
        IMAGEANLZ.(tab)(2).SetSlice(slice(3));
        IMAGEANLZ.(tab)(3).SetSlice(slice(1));
    end 
end