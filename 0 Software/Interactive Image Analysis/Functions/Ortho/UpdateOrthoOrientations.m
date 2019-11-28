%===================================================
%
%===================================================
function UpdateOrthoOrientations(tab)

global IMAGEANLZ

if strcmp(IMAGEANLZ.(tab)(1).ORIENT,'Axial')
    IMAGEANLZ.(tab)(2).SetOrient('Sagittal',1);
    IMAGEANLZ.(tab)(3).SetOrient('Coronal',1);
elseif strcmp(IMAGEANLZ.(tab)(1).ORIENT,'Sagittal')
    IMAGEANLZ.(tab)(2).SetOrient('Coronal',1);
    IMAGEANLZ.(tab)(3).SetOrient('Axial',1);
elseif strcmp(IMAGEANLZ.(tab)(1).ORIENT,'Coronal')
    IMAGEANLZ.(tab)(2).SetOrient('Axial',1);
    IMAGEANLZ.(tab)(3).SetOrient('Sagittal',1);
end