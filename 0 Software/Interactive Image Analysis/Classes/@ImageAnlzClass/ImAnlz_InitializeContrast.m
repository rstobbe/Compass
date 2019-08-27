%============================================
% 
%============================================
function ImAnlz_InitializeContrast(IMAGEANLZ)

Image = IMAGEANLZ.GetCurrent3DImageComplex;
if isreal(Image)
    IMAGEANLZ.MaxImVal = max(Image(:));
    IMAGEANLZ.MinImVal = min(Image(:));
else
    IMAGEANLZ.MaxImVal = max(abs(Image(:)));
    IMAGEANLZ.MinImVal = -max(abs(Image(:)));
end
ImAnlz_UpdateContrastTypeChange(IMAGEANLZ);
    