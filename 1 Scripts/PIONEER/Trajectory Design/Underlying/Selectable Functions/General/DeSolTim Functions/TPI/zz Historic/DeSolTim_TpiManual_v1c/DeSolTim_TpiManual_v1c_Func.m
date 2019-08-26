%====================================================
% 
%====================================================

function [DESOL,err] = DeSolTim_TpiManual_v1c_Func(DESOL,INPUT)

Status2('busy','Determine Solution Timing',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
RADEV = INPUT.RADEV;
TPIT = INPUT.TPIT;
clear INPUT;

%---------------------------------------------
% Function Setup
%---------------------------------------------
deradsolinfunc = str2func(['@(r,p)' RADEV.deradsolinfunc]);
deradsolinfunc = @(r) deradsolinfunc(r,PROJdgn.p);
deradsoloutfunc = str2func(['@(r,p)' RADEV.deradsoloutfunc]);
deradsoloutfunc = @(r) deradsoloutfunc(r,PROJdgn.p);

INPUT.TPIT = TPIT;
INPUT.deradsolfunc = deradsolinfunc;
defuncIn = @(t,r) TPIT.radevin(t,r,INPUT);
INPUT.deradsolfunc = deradsoloutfunc;
defuncOut = @(t,r) TPIT.radevout(t,r,INPUT);
clear INPUT

%------------------------------------------
% Calculate Projection Lengths
%------------------------------------------
Status2('busy','Calculate Trajectory Lengths',2);
[plout,err] = ProjLenOutside(PROJdgn.p,defuncOut,RADEV.outtol);                    
if err.flag == 1
    return
end
[plin,err] = ProjLenInside(PROJdgn.p,defuncIn,RADEV.intol);     
if err.flag == 1
    return
end

%------------------------------------------
% Create Timing Arrays for Solving
%------------------------------------------
Status2('busy','Create Timing Vector',2);

% Nin = 200;
% Nout = 300;
Nin = DESOL.nin;
Nout = DESOL.nout;
Trans = DESOL.trans;

%------------------------------------------
% Inside Points
%------------------------------------------
tau1 = -plin + plin*((1:Nin)/Nin);
tau1 = flip(tau1);

%------------------------------------------
% Outside Points
%------------------------------------------                                   
T = Nout/Trans;                       
tau2 = (-plin+plin*((Nin:Nout+Nin)/Nin)).*exp(-(0:Nout)/T) + (1.3*plout*((0:Nout)/Nout)).*(1-exp(-(0:Nout)/T));
SlvEnd = find(tau2 >= plout,1,'first');
if isempty(SlvEnd)
    error;              % increase ratio in front of plout
end
tau2 = tau2(1:SlvEnd);                                 
test = tau2(end)

%------------------------------------------
% Return
%------------------------------------------
DESOL.tau1 = tau1;
DESOL.tau2 = tau2;
DESOL.len = length(tau1)+length(tau2);
DESOL.plin = plin;
DESOL.plout = plout;
DESOL.PanelOutput = struct();

Status2('done','',2);
Status2('done','',3);

%===============================================================
% Inside
%===============================================================
function [projlen,err] = ProjLenInside(p,defunc,tol)

options = odeset('RelTol',tol,'AbsTol',tol);
projlen = [];
err.flag = 0;
err.msg = '';
tau = (0:-0.01:-200);

[x,r] = ode113(defunc,tau,p,options);   
ind = find(r < 0,1,'first');
if isempty(ind)
    error('tolerance set too high - fix');
end
ind = ind+1;
tau = (0:x(ind)/1e5:x(ind));
[x,r] = ode113(defunc,tau,p,options);  
projlen = abs(interp1(r,tau,0,'spline'));

%===============================================================
% Outside
%===============================================================
function [projlen,err] = ProjLenOutside(p,defunc,tol)

options = odeset('RelTol',tol,'AbsTol',tol);
projlen = [];
err.flag = 0;
err.msg = '';
tau = (0:1:10000);

[x,r] = ode113(defunc,tau,p,options); 
ind = find(abs(r) > 1,1,'first');
if isempty(ind)
    error;          % find error to return
%     err.flag = 1;
%     err.msg = '?';
%     return
end
ind = ind+1;
tau = (0:x(ind)/1e5:x(ind));
[x,r] = ode113(defunc,tau,p,options); 
projlen = interp1(abs(r),tau,1,'spline');

