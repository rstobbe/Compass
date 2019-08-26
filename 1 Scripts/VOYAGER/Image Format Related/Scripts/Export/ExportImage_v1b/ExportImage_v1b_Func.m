%====================================================
%  
%====================================================

function [EXPORT,err] = ExportImage_v1b_Func(EXPORT,INPUT)

Status('busy','Export Image');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG;
EF = INPUT.EF;
MANIP = INPUT.MANIP;
clear INPUT;

%---------------------------------------------
% Test Input
%---------------------------------------------
if iscell(IMG)
    if length(IMG) > 1
        err.flag = 1;
        err.msg = 'IMG cell array greater than 1';
        return
    else
        IMG = IMG{1};
    end
end

%---------------------------------------------
% Manipulate Image
%---------------------------------------------
func = str2func([EXPORT.manipfunc,'_Func']); 
INPUT.IMG = IMG;
[MANIP,err] = func(MANIP,INPUT);
if err.flag
    return
end
clear INPUT;
IMG = MANIP.IMG;

%----------------------------------------------
% Export Image
%----------------------------------------------
func = str2func([EXPORT.exportfunc,'_Func']);  
INPUT.IMG = IMG;
INPUT.folder = IMG.path;
if isfield(IMG,'name')
    if strfind(IMG.name,'IMG_')
        name = IMG.name(5:end);
    else
        name = IMG.name;
    end
    INPUT.imagename = name;
else
    INPUT.imagename = '';
end
if strfind(INPUT.imagename,'.')
    INPUT.imagename = strtok(INPUT.imagename,'.');
end
[EF,err] = func(EF,INPUT);
if err.flag
    return
end
clear INPUT;
EXPORT.name = EF.name;
EXPORT.file = EF.file;
EXPORT.path = EF.path;

%----------------------------------------------
% Load to COMPASS
%----------------------------------------------
if strcmp(EXPORT.loadoption,'Yes')
    Load_Image_Auto('IM',EXPORT.file,EXPORT.path);
end

Status('done','');
Status2('done','',2);
Status2('done','',3);

