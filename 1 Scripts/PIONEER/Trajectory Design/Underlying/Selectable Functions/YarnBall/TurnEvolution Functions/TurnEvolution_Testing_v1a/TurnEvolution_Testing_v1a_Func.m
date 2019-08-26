%====================================================
%
%====================================================

function [TURNEVO,err] = TurnEvolution_Testing_v1a_Func(TURNEVO,INPUT)

Status2('done','Turn Evolution',3);

err.flag = 0;
err.msg = '';

turnloc = INPUT.turnloc;
fiddle = INPUT.fiddle;
clear INPUT;

%---------------------------------------------
% Turn Function
%---------------------------------------------
Slope1 = 25;
Slope2 = 100;
Slope3 = 100;
TURNEVO.turnradfunc = @(p,r) (p^2/r^2)*(1 - 1/exp(Slope1*(1-r+fiddle)) + 1/exp(Slope1*(1-turnloc+fiddle)) - 1/exp(Slope2*(1-r^2+fiddle)) + 1/exp(Slope2*(1-turnloc^2+fiddle)) - 1/exp(Slope3*(1-r^4+fiddle)) + 1/exp(Slope3*(1-turnloc^4+fiddle)));
TURNEVO.turnspinfunc = @(p,r) (p^2/r^2);

Status2('done','',3);

