%====================================================
% 
%====================================================

function [DESOL,err] = DeSolTim_TpiManual_v1e_Func(DESOL,INPUT)

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
courseadjust = INPUT.courseadjust;
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
[plin,err] = ProjLenInside(PROJdgn.p,defuncIn,DESOL);     
if err.flag == 1
    return
end

%------------------------------------------
% Create Timing Arrays for Solving
%------------------------------------------
Status2('busy','Create Timing Vector',2);
T = DESOL.shape*1e-10;
V = DESOL.fine;
if strcmp(courseadjust,'yes')
    T = T*10;
    V = V*10;
    res = 1e13;
else
    if PROJdgn.p < 0.15
        res = 1e14;
    else
        res = 1e14;
    end
end

%------------------------------------------
% Timing Array
%------------------------------------------
t = (0:1e6);
tau = -plin + V*exp(T*t.^2.5) - V;
ind = find(tau > 0,1,'first');
t = t(1:ind);
n = 1;
dir = 1;

while true
    tau = -plin + V*exp(T*t.^2.5) - V;
    tauend = tau(end);
    %test = round(tauend*res)
    if round(tauend*res) == 0
        break
    end
    if tauend > 0
        if dir == 0
            n = n+1;
        end
        T = T - 10^-(10+n);
        dir = 1;
    else
        if dir == 1
            n = n+1;
        end
        T = T + 10^-(10+n);
        dir = 0;
    end
end

t = (0:1e6);
tau = -plin + V*exp(T*t.^2.5) - V;
tautest = round(tau*res);
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
    DESOL.Figure(1).Name = 'DeSolTim Characteristics';
    DESOL.Figure(1).Type = 'Graph';
    DESOL.Figure(1).hFig = fh;
    DESOL.Figure(1).hAx = gca;
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

%===============================================================
% Inside
%===============================================================
function [projlen,err] = ProjLenInside(p,defunc,DESOL)

err.flag = 0;
err.msg = '';

tau = (0:-1e-6:-1);
tol = 2e-6;
options = odeset('RelTol',tol,'AbsTol',tol);
[x,r] = ode113(defunc,tau,p,options);   
ind = find(r < 0,1,'first');

if strcmp(DESOL.Vis,'Yes')
    fh = figure(19283); 
    fh.Name = 'Solve Projection Inside';
    fh.NumberTitle = 'off';
    fh.Position = [500 500 900 300];
    subplot(1,2,1); hold on;
    plot(tau,r,'b');
    xlim([tau(ind+5) 0]);
    title('Inside Solution');
end

n = 1;
while true
    tau = [(0:-1e-6:x(ind-1)) x(ind-1)-n*3e-8];
    tol = 2.5e-14;
    options = odeset('RelTol',tol,'AbsTol',tol);
    [x,r] = ode113(defunc,tau,p,options);  
    if length(r) ~= length(tau)
        break
    end
    if strcmp(DESOL.Vis,'Yes')
        rend(n) = r(end);
        subplot(1,2,2); hold on;
        plot(rend); drawnow;
        title('Error at Zero');
    end
    rout = r;
    tauout = tau;
    n = n+1;
end
        
if strcmp(DESOL.Vis,'Yes')
    subplot(1,2,1); hold on;
    plot(tauout,rout,'r');
end
projlen = abs(interp1(rout,tauout,0,'spline'));

%===============================================================
% Outside
%===============================================================
function [projlen,err] = ProjLenOutside(p,defunc,tol)

err.flag = 0;
err.msg = '';
tau = (0:0.01:100);

while true
    options = odeset('RelTol',tol,'AbsTol',tol);
    [x,r] = ode113(defunc,tau,p,options); 
    ind = find(abs(r) > 1,1,'first');
    if not(isempty(ind))
        break;          
    end
    tol = tol/2;
end

ind = ind+10;
tau = (0:x(ind)/1e5:x(ind));
while true
    options = odeset('RelTol',tol,'AbsTol',tol);
    [x,r] = ode113(defunc,tau,p,options); 
    ind = find(abs(r) > 1,1,'first');
    if not(isempty(ind))
        projlen = interp1(abs(r),tau,1,'spline');
        break;          
    end
    tol = tol/2;
end

