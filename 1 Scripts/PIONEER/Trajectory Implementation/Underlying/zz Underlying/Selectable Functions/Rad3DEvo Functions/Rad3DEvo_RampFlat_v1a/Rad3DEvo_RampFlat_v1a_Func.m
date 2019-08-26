%=============================================================
% 
%=============================================================

function [REVO,err] = Rad3DEvo_RampFlat_v1a_Func(REVO,INPUT)

Status2('busy','Radial Evolution Ramp-Flat',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
PROJimp = INPUT.PROJimp;
GQNT = INPUT.GQNT;
qT0 = INPUT.qT0;
clear INPUT;

%---------------------------------------------
% Ramp-Up
%---------------------------------------------
B = -PROJdgn.tro*(2*REVO.ramp);
C = (PROJdgn.kmax/PROJimp.gamma)*(2*REVO.ramp);
Gmax = (-B - sqrt(B^2 - 4*C))/2;

Traj = Gmax*ones(1,length(qT0));
Ramp = (REVO.ramp*GQNT.gseg:REVO.ramp*GQNT.gseg:Gmax);
Traj(1:length(Ramp)) = Ramp;

RadEvo(1) = 0;
for m = 1:length(Traj)-1
    RadEvo(m+1) = Traj(m)*GQNT.gseg*PROJimp.gamma + RadEvo(m);
end
REVO.RadEvo = PROJdgn.kmax*RadEvo/RadEvo(end);

%---------------------------------------------
% Return
%---------------------------------------------
Status2('done','',3);


