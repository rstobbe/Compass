%====================================================
% 
%====================================================

function [DESOL,err] = DeSolTim_TpiQuickTest_v1d_Func(DESOL,INPUT)

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
[plin,err] = ProjLenInside(PROJdgn.p,defuncIn);     
if err.flag == 1
    return
end

%------------------------------------------
% Create Timing Arrays for Solving
%------------------------------------------
Status2('busy','Create Timing Vector',2);
T = DESOL.shape*1e-10;
V = DESOL.fine;

%------------------------------------------
% Timing Array
%------------------------------------------
t = (0:1e6);
tau = -plin + V*exp(T*t.^2.5) - V;
ind = find(tau > 0,1,'first');
t = t(1:ind);
n = 1;
while true
    tau = -plin + V*exp(T*t.^2.5) - V;
    T
    tauend = tau(end)
    if round(tauend*1e15) == 0
        break
    end
    if tauend > 0
        T = T*(0.9999^(1/n));
        if rem(n,2)
            n = n+1;
        end
    else
        T = T*(1.0001^(1/n));
        if rem(n-1,2)
            n = n+1;
        end
    end
end

t = (0:1e6);
tau = -plin + V*exp(T*t.^2.5) - V;
tautest = round(tau*1e15);
ind2 = find(tautest <= 0,1,'last');  
ind3 = find(tautest >= 0,1,'first');
if ind2 ~= ind3
    error
end

SlvZero = ind2;
tau1 = flip(tau(2:SlvZero),2);
inc = ((tau(1)-tau(2))/50);
tau1 = [tau1 tau(1)-inc];
%test = tau1(end-2:end)
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
    ylim([tau(1) tau(SlvEnd)]);
    %ylim([tau(1) 0.01]);
    xlabel('DE sample point'); ylabel('Tau (projlen)'); title('DE Solution Timing Vector');    
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
function [projlen,err] = ProjLenInside(p,defunc)

err.flag = 0;
err.msg = '';
tau = (0:-1e-5:-1);
tol = 1e-5;
options = odeset('RelTol',tol,'AbsTol',tol);
[x,r] = ode113(defunc,tau,p,options);   
projlen = abs(interp1(r,tau,0,'spline'));

%===============================================================
% Outside
%===============================================================
function [projlen,err] = ProjLenOutside(p,defunc,tol)

err.flag = 0;
err.msg = '';
options = odeset('RelTol',tol,'AbsTol',tol);
tau = (0:1:10000);
[x,r] = ode113(defunc,tau,p,options); 
ind = find(abs(r) > 1,1,'first');
if isempty(ind)
    error;          
end
ind = ind+1;
tau = (0:x(ind)/1e5:x(ind));
[x,r] = ode113(defunc,tau,p,options); 
projlen = interp1(abs(r),tau,1,'spline');
