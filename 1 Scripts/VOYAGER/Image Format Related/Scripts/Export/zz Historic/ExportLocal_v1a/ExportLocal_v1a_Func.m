%====================================================
%  
%====================================================

function [EXPORT,err] = ExportLocal_v1a_Func(EXPORT,INPUT)

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
imagename = INPUT.imagename;
clear INPUT;

%---------------------------------------------
% Select Location
%---------------------------------------------
folder = uigetdir('Y:\E Experiments\','Select Folder to Export Into');
if folder == 0
    err.flag = 4;
    err.msg = '';
    return
end

%----------------------------------------------
% Export Image
%----------------------------------------------
func = str2func([EXPORT.exportfunc,'_Func']);  
INPUT.IMG = IMG;
INPUT.folder = folder;
INPUT.imagename = imagename;
[EF,err] = func(EF,INPUT);
if err.flag
    return
end
clear INPUT;

Status('done','');
Status2('done','',2);
Status2('done','',3);

