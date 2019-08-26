%=========================================================
% 
%=========================================================

function dM = StandardBlochRFphase_v1a_DE(t,M,BLOCH,INPUT)

%---------------------------------------------
% Get Input
%---------------------------------------------
T1 = INPUT.T1;              % (ms)
T2 = INPUT.T2;              % (ms)
w1 = INPUT.w1;              % (rad/ms)
time = INPUT.time;          % (ms)
woff = INPUT.woff;          % (rad/ms)
phase = INPUT.phase;        % (rad)
clear INPUT

w1 = interp1(time,w1,t);
woff = interp1(time,woff,t);

%-----------------------------------------
% Differential Equantions (as Haacke page 61)
%-----------------------------------------
M0 = 1;
dM = zeros(3,1);				

dM(1) = (-sin(phase)*w1 * M(3)) + (-cos(phase)*w1 * M(2)) + (M0 - M(1))/T1;               % M(1) = z
dM(2) = (woff * M(3)) + (cos(phase)*w1 * M(1)) - M(2)/T2;       % M(2) = x
dM(3) = (-woff * M(2)) + (sin(phase)*w1 * M(1)) - M(3)/T2;      % M(3) = y

