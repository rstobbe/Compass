%====================================================
%
%====================================================

function [TURNSOL,err] = TurnSolution_Standard_v1b_Func(TURNSOL,INPUT)

Status2('busy','Turn Evolution',3);

err.flag = 0;
err.msg = '';

DESTYPE = INPUT.DESTYPE;
CLR = INPUT.CLR;
clear INPUT;

%---------------------------------------------
% Create Radial Evolution Functions
%---------------------------------------------
INPUT = DESTYPE.DESTRCT;
INPUT.turnradfunc = DESTYPE.TURNEVO.turnradfunc;
INPUT.turnspinfunc = DESTYPE.TURNEVO.turnspinfunc;
INPUT.deradsolfunc = DESTYPE.DESTRCT.deradsoloutfunc;
DESTYPE.radevout = @(t,r) CLR.radevout(t,r,INPUT);
INPUT.deradsolfunc = DESTYPE.DESTRCT.deradsolinfunc;   
DESTYPE.radevin = @(t,r) CLR.radevin(t,r,INPUT);

%---------------------------------------------
% Determine How Far to Solve
%---------------------------------------------
TURNSOL.maxradderivative = 0.001;
n = 1;
for r = 0.99:0.000001:2
    dr(n) = DESTYPE.radevout(0,r);
    if dr(n) < TURNSOL.maxradderivative
        break
    end
    n = n+1;
end
TURNSOL.MaxRadSolve = r;
TURNSOL.rArr = (0.99:0.000001:r);
TURNSOL.drArr = dr;

TURNSOL.DESTYPE = DESTYPE;

Status2('done','',3);