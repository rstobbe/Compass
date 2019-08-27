%===================================================
%
%===================================================
function InitializeOrthoPresentation(tab)

global IMAGEANLZ

for n = 1:3
    IMAGEANLZ.(tab)(n).TieSlice(0);
    IMAGEANLZ.(tab)(n).TieZoom(0);
    IMAGEANLZ.(tab)(n).TieDims(1);
    IMAGEANLZ.(tab)(n).TieDatVals(0); 
    IMAGEANLZ.(tab)(n).TieCursor(0); 
    IMAGEANLZ.(tab)(n).TieRois(0); 
    IMAGEANLZ.(tab)(n).ShowOrthoLine(1);
    IMAGEANLZ.(tab)(n).ShadeROIChange(1);
end
IMAGEANLZ.(tab)(1).AutoUpdateROIChange(1);
IMAGEANLZ.(tab)(1).FIGOBJS.ShowOrtho.Value = 1;
IMAGEANLZ.(tab)(1).FIGOBJS.ShadeROI.Value = 1;
IMAGEANLZ.(tab)(1).FIGOBJS.AutoUpdateROI.Value = 1;

UpdateOrthoOrientations(tab);