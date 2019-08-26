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
dfilename = INPUT.dfilename;
clear INPUT;

%----------------------------------------------
% Export Image
%----------------------------------------------
func = str2func([EXPORT.exportfunc,'_Func']);  
INPUT.IMG = IMG;
INPUT.dfilename = dfilename;
[EF,err] = func(EF,INPUT);
if err.flag
    return
end
clear INPUT;

Status('done','');
Status2('done','',2);
Status2('done','',3);

