%=========================================================
% 
%
%=========================================================

function dM = CoupledBloch_v1a_DE(t,M,BLOCH,INPUT)

%---------------------------------------------
% Get Input
%---------------------------------------------
%rM0B = INPUT.M0B;
%M0B = rM0B/(rM0B+1);
%M0A = 1-M0B;
M0A = 1;
M0B = INPUT.M0B;
T1A = INPUT.T1A;
T1B = INPUT.T1B;
T2A = INPUT.T2A;
T2B = INPUT.T2B;
EXR = INPUT.EXR;
w1 = INPUT.w1*2*pi/1000;
woff = INPUT.woff*2*pi/1000;            % w1 & woff = rad/msec
clear INPUT

%---------------------------------------------
% 
%---------------------------------------------
dM = zeros(4,1);				

dM(1) = (M0A - M(1))/T1A - EXR*M0B*M(1) + EXR*M0A*M(2) + w1*M(4);                       % M(1) = MzA (liquid pool)
dM(2) = (M0B - M(2))/T1B - EXR*M0A*M(2) + EXR*M0B*M(1) + w1*M(6);                       % M(2) = MzB (bound pool)
dM(3) = -M(3)/T2A - woff*M(4);                                                          % M(3) = MxA (liquid pool)
dM(4) = -M(4)/T2A + woff*M(3) -w1*M(1);                                                 % M(4) = MyA (liquid pool)
dM(5) = -M(5)/T2B - woff*M(6);                                                          % M(3) = MxB (bound pool)
dM(6) = -M(6)/T2B + woff*M(5) -w1*M(2);                                                 % M(4) = MyB (bound pool)
