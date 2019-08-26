%=========================================================
% 
%=========================================================

function [TSTTOP,err] = SampDensCompTest_Proj3D_v1a_Func(TSTTOP,INPUT)

Status('busy','Test Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
SDCS = INPUT.SDCS;
TST = INPUT.TST;
clear INPUT

%---------------------------------------------
% Plot
%---------------------------------------------
func = str2func([TST.method,'_Func']);  
INPUT.SDCS = SDCS;
[TST,err] = func(TST,INPUT);
if err.flag
    return
end
clear INPUT;
