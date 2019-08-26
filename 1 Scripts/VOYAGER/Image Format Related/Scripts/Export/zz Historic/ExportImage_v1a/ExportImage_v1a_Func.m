%====================================================
%  
%====================================================

function [EXPORT,err] = ExportImage_v1a_Func(EXPORT,INPUT)

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

%----------------------------------------------
% Export Image
%----------------------------------------------
func = str2func([EXPORT.exportfunc,'_Func']);  
INPUT.IMG = IMG;
INPUT.folder = IMG.path;
if isfield(IMG,'name')
    INPUT.imagename = IMG.name;
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

Status('done','');
Status2('done','',2);
Status2('done','',3);

