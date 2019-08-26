%====================================================
%
%====================================================

function [TURNEVO,err] = TurnEvolution_Erf_v1b_Func(TURNEVO,INPUT)

Status2('done','Turn Evolution',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Turn Function
%---------------------------------------------

Start = TURNEVO.start;
Slope = TURNEVO.slope;
TURNEVO.turnradfunc = @(p,r) p^2*(erf(Start+Slope*(1-r^2)) + (1-erf(Start)));
%TURNEVO.turnradfunc = @(p,r) p^2*erf(2.0+100*(1-r));

TURNEVO.turnspinfunc = @(p,r) (p^2/r^2);

Status2('done','',3);

