%====================================================
%  
%====================================================

function [MATCH,err] = Match2Images_v1a_Func(MATCH,INPUT)

Status('busy','Match 2 Images (FoV / Matrix)');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
IMG1 = INPUT.IMG1;
IMG2 = INPUT.IMG2;
RSZ = INPUT.RSZ;
DISP = INPUT.DISP;
clear INPUT;

%---------------------------------------------
% Resize
%---------------------------------------------
func = str2func([MATCH.resizefunc,'_Func']);  
INPUT.IMG1 = IMG1;
INPUT.IMG2 = IMG2;
[RSZ,err] = func(RSZ,INPUT);
if err.flag
    return
end
clear INPUT;
IMG = RSZ.IMG;

%---------------------------------------------
% Display
%---------------------------------------------
func = str2func([MATCH.dispfunc,'_Func']);  
INPUT.IMG1 = IMG1;
INPUT.IMG2 = IMG;
[DISP,err] = func(DISP,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
MATCH.IMG = IMG;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);