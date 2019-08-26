%===========================================
% 
%===========================================

function [BASE,err] = FirstImage_v1a_Func(BASE,INPUT)

Status2('busy','Get Base Image for Mapping',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return
%---------------------------------------------
BASE.Im = INPUT.Im(:,:,:,:,:,1);

Status2('done','',2);
Status2('done','',3);

