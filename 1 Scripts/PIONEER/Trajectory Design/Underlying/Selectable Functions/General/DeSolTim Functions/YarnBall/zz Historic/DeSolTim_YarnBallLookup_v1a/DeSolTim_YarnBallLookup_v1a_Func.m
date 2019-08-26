%====================================================
% 
%====================================================

function [DESOL,err] = DeSolTim_YarnBallLookup_v1a_Func(DESOL,INPUT)

Status2('busy','Determine Solution Timing',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test for Common Routines
%---------------------------------------------
DESOL.projlenoutfunc = 'LR1_ProjLenOutside_v1d';
DESOL.projleninfunc = 'LR1_ProjLenInside_v1d';
if not(exist(DESOL.projlenoutfunc,'file'))
    err.flag = 1;
    err.msg = 'Folder with DESOL routines must be added to path';
    return
end
projlenoutfunc = str2func(DESOL.projlenoutfunc);
projleninfunc = str2func(DESOL.projleninfunc);

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
TST = INPUT.TST;
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
[plout,err] = projlenoutfunc(PROJdgn.p,PROJdgn.spiralaccom,deradsoloutfunc,RADEV.outtol);                    
if err.flag == 1
    return
end
[plin,err] = projleninfunc(PROJdgn.p,deradsolinfunc,RADEV.intol);     
if err.flag == 1
    return
end

%------------------------------------------
% Create Timing Arrays for Solving
%------------------------------------------
Status2('busy','Create Timing Vector',2);
[Nin0,T] = Lookup(plin,plout,TST);

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
% Lookup
%===============================================================
function [Nin,OutShape] = Lookup(plin,plout,TST)

if plin < 0.04
    Nin = 3000;                      
else
    error
end

if plout > 25               
    OutShape = 0.35e-3;       
else
    error
end
      
%---------------------------------------------
% Testing
%--------------------------------------------- 
if strcmp(TST.testspeed,'Rapid')
    Nin = Nin/5;
    OutShape = OutShape*5;
end
