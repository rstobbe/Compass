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
    IMAGEANLZ.('IM')(1).IMPATH = impath;
    IMAGEANLZ.('IM4')(1).IMPATH = impath;
end
    
%---------------------------------------------------------
% Import Image
%---------------------------------------------------------
[IMG,Name,ImType,err] = Import_Image(impath,imfile);
if err.flag
    return
end

%---------------------------------------------------------
% Write To Global
%---------------------------------------------------------
for n = 1:length(IMG)
    totalgbl{1} = Name{n};
    totalgbl{2} = IMG{n};
    from = 'CompassLoad';
    Load_TOTALGBL(totalgbl,tab,from);
end


