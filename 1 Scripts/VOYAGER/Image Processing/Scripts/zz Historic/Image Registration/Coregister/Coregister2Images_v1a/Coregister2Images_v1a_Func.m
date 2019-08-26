%====================================================
%  
%====================================================

function [COREG,err] = Coregister2Images_v1a_Func(COREG,INPUT)

Status('busy','Coregister2Images');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
IMG = INPUT.IMG;
REGFNC = INPUT.REGFNC;
clear INPUT;

%---------------------------------------------
% Sort Input
%---------------------------------------------
if iscell(IMG)
    if length(IMG) == 1
        IMG = IMG{1};
        Image = IMG.Im;
        sz = size(Image);
        if sz(4) ~= 2
            error;
        end
    end
end

%---------------------------------------------
% Align
%---------------------------------------------
func = str2func([COREG.coregfunc,'_Func']);  
INPUT.Image = Image;
[REGFNC,err] = func(REGFNC,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
COREG.Im = REGFNC.Im;

Status('done','');
Status2('done','',2);
Status2('done','',3);

