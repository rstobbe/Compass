%===================================================
% Load Image
%===================================================

function Load_Image(tab)

global IMAGEANLZ
global COMPASSINFO
%---------------------------------------------------------
% Select Image File
%---------------------------------------------------------
DefFileType = IMAGEANLZ.(tab)(1).IMFILETYPE;
DefPath = IMAGEANLZ.(tab)(1).IMPATH;

%---------------------------------------------------------
% Select Image File
%---------------------------------------------------------
if isempty(DefPath)
    IMAGEANLZ.(tab)(1).IMPATH = COMPASSINFO.USERGBL.experimentsloc;
    DefPath = IMAGEANLZ.(tab)(1).IMPATH;
end

[imfile,impath,err] = Select_Image(DefPath,DefFileType);
if err.flag
    return
end
IMAGEANLZ.('IM2')(1).IMPATH = impath;
IMAGEANLZ.('IM3')(1).IMPATH = impath;
if not(strcmp(COMPASSINFO.USERGBL.setup,'ImageAnalysis'))
    IMAGEANLZ.('IM1')(1).IMPATH = impath;
    IMAGEANLZ.('IM4')(1).IMPATH = impath;
end
    
%---------------------------------------------------------
% Import Image
%---------------------------------------------------------
[IMG,Name,ImType,err] = Import_Image(impath,imfile);
if err.flag
    return
end
IMAGEANLZ.('IM')(1).IMFILETYPE = ImType;
IMAGEANLZ.('IM2')(1).IMFILETYPE = ImType;
IMAGEANLZ.('IM3')(1).IMFILETYPE = ImType;
IMAGEANLZ.('IM4')(1).IMFILETYPE = ImType;

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


