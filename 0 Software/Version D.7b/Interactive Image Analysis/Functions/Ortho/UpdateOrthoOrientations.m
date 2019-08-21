%===================================================
%
%===================================================
function UpdateOrthoOrientations(tab)

global IMAGEANLZ

if strcmp(IMAGEANLZ.(tab)(1).ORIENT,'Axial')
    IMAGEANLZ.(tab)(2).SetOrient('Sagittal');
    IMAGEANLZ.(tab)(3).SetOrient('Coronal');
elseif strcmp(IMAGEANLZ.(tab)(1).ORIENT,'Sagittal')
    IMAGEANLZ.(tab)(2).SetOrient('Coronal');
    IMAGEANLZ.(tab)(3).SetOrient('Axial');
elseif strcmp(IMAGEANLZ.(tab)(1).ORIENT,'Coronal')
    IMAGEANLZ.(tab)(2).SetOrient('Axial');
    IMAGEANLZ.(tab)(3).SetOrient('Sagittal');
end