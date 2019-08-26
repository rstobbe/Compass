%=========================================================
% 
%=========================================================

function [WRT,err] = SysWrt_v1a_Func(INPUT,WRT)

Status('busy','Write Gradients Etc For Different Systems');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
WRTSYS = INPUT.WRTSYS;
IMP = INPUT.IMP;
clear INPUT;
  
%---------------------------------------------
% Write SSYS
%---------------------------------------------
func = str2func([WRT.wrtsysfunc,'_Func']);
INPUT.IMP = IMP;
INPUT.G = IMP.G;
[WRTSYS,err] = func(WRTSYS,INPUT);
if err.flag
    return
end
clear INPUT


