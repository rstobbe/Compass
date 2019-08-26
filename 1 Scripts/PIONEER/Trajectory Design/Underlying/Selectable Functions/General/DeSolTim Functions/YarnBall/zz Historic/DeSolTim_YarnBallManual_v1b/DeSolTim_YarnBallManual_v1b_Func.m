%====================================================
% 
%====================================================

function [DESOL,err] = DeSolTim_YarnBallManual_v1b_Func(DESOL,INPUT)

Status2('busy','Determine Solution Timing',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
courseadjust = INPUT.courseadjust;
RADEV = INPUT.RADEV;
clear INPUT;

%---------------------------------------------
% Function Setup
%---------------------------------------------
deradsolinfunc = str2func(['@(r,p)' RADEV.deradsolinfunc]);
deradsolinfunc = @(r) deradsolinfunc(r,PROJdgn.p);
deradsoloutfunc = str2func(['@(r,p)' RADEV.deradsoloutfunc]);
deradsoloutfunc = @(r) deradsoloutfunc(r,PROJdgn.p);

%------------------------------------------
% Calculate Projection Lengths
%------------------------------------------
Status2('busy','Calculate Trajectory Lengths',2);
[plout,err] = ProjLenOutside(PROJdgn.p,PROJdgn.spiralaccom,deradsoloutfunc,RADEV.outtol);                    
if err.flag == 1
    return
end
[plin,err] = ProjLenInside(PROJdgn.p,deradsolinfunc,RADEV.intol);     
if err.flag == 1
    return
end

%------------------------------------------
% Create Timing Arrays for Solving
%------------------------------------------
Status2('busy','Create Timing Vector',2);
Nin0 = DESOL.nin;
T = DESOL.outshape*1e-3;
if strcmp(courseadjust,'yes')
    Nin0 = Nin0/5;
    T = T*5;
end

%------------------------------------------
% Inside Points
%------------------------------------------
Nin = Nin0;
tMax = 1e6;                                             % doesn't really matter just set sufficiently big
t = (0:tMax); 
tau = -plin + plin/Nin*t + exp(T*(t-Nin)) - exp(-T*Nin);
while true
    ind = find(tau > 0,1,'first');
    if isempty(ind)
        error
    end
    if ind < Nin0
        Nin = Nin*1.05;
    else
        break
    end
    tau = -plin + plin/Nin*t + exp(T*(t-Nin)) - exp(-T*Nin);
end

%------------------------------------------
% Solve Middle
%------------------------------------------                                   
tau = -plin + plin/Nin*t + exp(T*(t-Nin)) - exp(-T*Nin);
ind = find(tau > plout,1);
if isempty(ind)
    error
end

ind1 = find(tau <= 0,1,'last');  
short1 = abs(tau(ind1));
rateinc1 = (short1/(ind1-1));

tau = -plin + (plin/Nin+rateinc1)*t + exp(T*(t-Nin)) - exp(-T*Nin);

tautest = round(tau*1e15);
ind2 = find(tautest <= 0,1,'last');  
ind3 = find(tautest >= 0,1,'first'); 
if ind2 ~= ind3
    error
end

SlvZero = ind2;
tau1 = flip(tau(2:SlvZero),2);
SlvEnd = find(tau >= plout,1,'first');
tau2 = tau(SlvZero:SlvEnd);                                 % will solve a tiny bit past

%------------------------------------------
% Visualize
%------------------------------------------
if strcmp(DESOL.Vis,'Yes')
    figure(92); hold on; plot(tau(1:SlvEnd),'b-');
    plot(SlvZero,tau(SlvZero),'r*');
    xlabel('sample point'); ylabel('tau'); title('Timing Vector');    
end

%------------------------------------------
% Test
%------------------------------------------
if tau(2) < tau(1)
    err.flag = 1;
    err.msg = 'Timing Vector Problem (negative)';
    return
end

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
function [projlen,err] = ProjLenInside(p,deradsolfunc,tol)

options = odeset('RelTol',tol,'AbsTol',tol);
err.flag = 0;
err.msg = '';
tau = (0:-0.01:-200);

INPUT.deradsolfunc = deradsolfunc;
INPUT.p = p;
defunc = @(t,r) Rad_Sol(t,r,INPUT);

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
function [projlen,err] = ProjLenOutside(p,R,deradsolfunc,tol)

options = odeset('RelTol',tol,'AbsTol',tol);
projlen = '';
err.flag = 0;
err.msg = '';
tau = (0:1:10000);

INPUT.deradsolfunc = deradsolfunc;
INPUT.p = p;
defunc = @(t,r) Rad_Sol(t,r,INPUT);

[x,r] = ode113(defunc,tau,p,options); 
ind = find(abs(r) > R,1,'first');
if isempty(ind)
    err.flag = 1;
    err.msg = 'Matrix Diameter and Number of Projections Impractical';
    return
end
ind = ind+1;
tau = (0:x(ind)/1e5:x(ind));
[x,r] = ode113(defunc,tau,p,options); 
projlen = interp1(abs(r),tau,R,'spline');

%===============================================================
% Rad_Sol
%===============================================================
function dr = Rad_Sol(t,r,INPUT) 

deradsolfunc = INPUT.deradsolfunc;
p = INPUT.p;
dr = p^2/(r^2*deradsolfunc(r));    

