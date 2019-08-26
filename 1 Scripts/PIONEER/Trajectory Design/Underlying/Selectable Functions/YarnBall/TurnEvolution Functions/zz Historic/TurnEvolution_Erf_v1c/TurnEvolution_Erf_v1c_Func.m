%====================================================
%
%====================================================

function [TURNEVO,err] = TurnEvolution_Erf_v1c_Func(TURNEVO,INPUT)

Status2('done','Turn Evolution',3);

err.flag = 0;
err.msg = '';

turnloc = INPUT.turnloc;
clear INPUT;

%---------------------------------------------
% Turn Function
%---------------------------------------------
Back = 1-turnloc;
Back = 0.0122;
Start = TURNEVO.start;
Slope = TURNEVO.slope;
TURNEVO.turnradfunc = @(p,r) (p^2/r^2)*(1 - erf(Start+Slope*(1-(turnloc+Back)^2)) + erf(Start+Slope*(1-(r+Back)^2)));
TURNEVO.turnspinfunc = @(p,r) (p^2/r^2);

Status2('done','',3);

