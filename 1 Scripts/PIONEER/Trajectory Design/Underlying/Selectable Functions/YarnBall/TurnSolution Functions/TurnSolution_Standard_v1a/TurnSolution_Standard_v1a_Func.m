%====================================================
%
%====================================================

function [TURNSOL,err] = TurnSolution_Standard_v1a_Func(TURNSOL,INPUT)

Status2('done','Turn Evolution',3);

err.flag = 0;
err.msg = '';

DESTYPE = INPUT.DESTYPE;
clear INPUT;

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


