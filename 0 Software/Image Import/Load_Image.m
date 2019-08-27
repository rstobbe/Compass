%===================================================
% Load Image
%===================================================

function Load_Image(tab)

global IMAGEANLZ
%---------------------------------------------------------
% Select Image File
%---------------------------------------------------------
DefFileType = IMAGEANLZ.(tab)(1).IMFILETYPE;
DefPath = IMAGEANLZ.(tab)(1).IMPATH;
[imfile,impath,err] = Select_Image(DefPath,DefFileType);
if err.flag
    return
end
IMAGEANLZ.(tab)(1).IMPATH = impath;

%---------------------------------------------------------
% Import Image
%---------------------------------------------------------
[IMG,Name,ImType,err] = Import_Image(impath,imfile);
if err.flag
    return
end
IMAGEANLZ.(tab)(1).IMFILETYPE = ImType;

%---------------------------------------------------------
% Name Image
%---------------------------------------------------------
%imname = inputdlg('Image Name:','Image Name',1,{Name});
%if isempty(imname)
%    return
%end
imname = {Name};

%---------------------------------------------------------
% Write To Global
%---------------------------------------------------------
totalgbl{1} = imname{1};
totalgbl{2} = IMG;
from = 'CompassLoad';
Load_TOTALGBL(totalgbl,tab,from);

