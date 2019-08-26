%====================================================
%  
%====================================================

function [MATCH,err] = Match2Images_v1b_Func(MATCH,INPUT)

Status('busy','Match 2 Images (FoV / Matrix)');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
IMG = INPUT.IMG;
RSZ = INPUT.RSZ;
DISP = INPUT.DISP;
clear INPUT;

%---------------------------------------------
% Resize
%---------------------------------------------
func = str2func([MATCH.resizefunc,'_Func']);  
INPUT.IMG1 = IMG{1};
INPUT.IMG2 = IMG{2};
[RSZ,err] = func(RSZ,INPUT);
if err.flag
    return
end
clear INPUT;
IMG2 = RSZ.IMG;

%---------------------------------------------
% Display
%---------------------------------------------
func = str2func([MATCH.dispfunc,'_Func']);  
INPUT.Im1 = IMG{1}.Im;
INPUT.Im2 = IMG2.Im;
[DISP,err] = func(DISP,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
MATCH.IMG = IMG2;

Status2('done','',1);
Status2('done','',2);
Status2('done','',3);