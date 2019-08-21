%===================================================
% Load Image
%===================================================

function Load_Image_Auto(tab,imfile,impath)

global IMAGEANLZ

%---------------------------------------------------------
% Import Image
%---------------------------------------------------------
[IMG,Name,ImType,err] = Import_Image(impath,imfile);
if err.flag
    return
end
IMAGEANLZ.(tab)(1).IMFILETYPE = ImType;
IMAGEANLZ.(tab)(1).IMPATH = impath;

%---------------------------------------------------------
% Write To Global
%---------------------------------------------------------
totalgbl{1} = Name;
totalgbl{2} = IMG;
from = 'Script';
Load_TOTALGBL(totalgbl,tab,from)


