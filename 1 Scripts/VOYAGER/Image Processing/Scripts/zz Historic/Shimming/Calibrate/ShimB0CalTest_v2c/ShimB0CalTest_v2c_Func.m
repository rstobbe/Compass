%===========================================
% 
%===========================================

function [SHIM,err] = ShimB0CalTest_v2c_Func(SHIM,INPUT)

Status2('busy','B0 Shimming Test',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test
%---------------------------------------------
B0SHIM = INPUT.B0SHIM;
clear INPUT;

%---------------------------------------------
% Shim
%---------------------------------------------
func = str2func([SHIM.shimfunc,'_Func']); 
INPUT = struct();
[B0SHIM,err] = func(B0SHIM,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Return
%---------------------------------------------

Status2('done','',2);
Status2('done','',3);

