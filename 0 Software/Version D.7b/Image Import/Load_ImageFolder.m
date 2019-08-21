%===================================================
% Load Image
%===================================================

function Load_ImageFolder(tab)

global IMAGEANLZ
%---------------------------------------------------------
% Select Image File
%---------------------------------------------------------
DefPath = IMAGEANLZ.(tab)(1).IMPATH;
[impath] = uigetdir(DefPath,'Select Folder');
if isempty(impath)
    return
end
IMAGEANLZ.(tab)(1).IMPATH = impath;
test = dir(impath);

%---------------------------------------------------------
% Find Images
%---------------------------------------------------------
for n = 1:length(test)
    if test(n).isdir
        continue
    end
    imfile = test(n).name;

    %---------------------------------------------------------
    % Import Image
    %---------------------------------------------------------
    [IMG,Name,ImType,err] = Import_Image([impath,'\'],imfile);
    if err.flag == 4
        continue
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
    from = 'Load';
    Load_TOTALGBL(totalgbl,tab,from);
end

