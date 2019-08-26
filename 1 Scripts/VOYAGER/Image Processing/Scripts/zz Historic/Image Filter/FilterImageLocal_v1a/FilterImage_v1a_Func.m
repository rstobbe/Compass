%===========================================
% 
%===========================================

function [FILTIM,err] = FilterImage_v1a_Func(FILTIM,INPUT)

Status2('busy','Filter Image',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
Im = INPUT.Im;
FILT = INPUT.FILT;
clear INPUT;

%---------------------------------------------
% Filter
%---------------------------------------------
func = str2func([FILTIM.filterfunc,'_Func']);  
INPUT.Im = Im;
[FILT,err] = func(FILT,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------
FILTIM.Im = FILT.Im;


Status2('done','',2);
Status2('done','',3);

