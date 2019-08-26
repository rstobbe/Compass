%====================================================
% 
%====================================================

function [DESOL,err] = DeSolTim_TpiManual_v1b_Func(DESOL,INPUT)

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
SN = 1e9;
tau = -plin + plin/Nin*t + exp(T*(t-(Nin/SN))) - exp(-T*(Nin/SN));

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
    tau = -plin + plin/Nin*t + exp(T*(t-(Nin/SN))) - exp(-T*(Nin/SN));
end

%------------------------------------------
% Solve Middle
%------------------------------------------                                   
tau = -plin + plin/Nin*t + exp(T*(t-(Nin/SN))) - exp(-T*(Nin/SN));
ind = find(tau > plout,1);
if isempty(ind)
    error
end

ind1 = find(tau <= 0,1,'last');  
short1 = abs(tau(ind1));
rateinc1 = (short1/(ind1-1));

tau = -plin + (plin/Nin+rateinc1)*t + exp(T*(t-(Nin/SN))) - exp(-T*(Nin/SN));

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
    fh = figure(92); hold on; 
    fh.Name = 'Test DE Sampling Timing';
    fh.NumberTitle = 'off';
    plot((1:SlvEnd),tau(1:SlvEnd));
    plot(SlvZero,tau(SlvZero),'r*');
    %ylim([tau(1) tau(SlvEnd)]);
    ylim([tau(1) 0.01]);
    xlabel('DE sample point'); ylabel('Tau (projlen)'); title('DE Solution Timing Vector');    
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

