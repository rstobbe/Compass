%=========================================================
% 
%=========================================================

function [SIMDES,err] = MT_1Pulse_Bloch_v1a_Func(SIMDES,INPUT)

Status('busy','Determine MT for During RF pulse using Bloch Equations');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
LINEVAL = INPUT.LINEVAL;
BLOCH = INPUT.BLOCH;
clear INPUT

%---------------------------------------------
% Get Variables
%---------------------------------------------
tauRF = SIMDES.tauRF;
segdur = 0.1;

%---------------------------------------------
% Build Saturation Rate Function
%---------------------------------------------
func = str2func([SIMDES.linevalfunc,'_Func']);  
INPUT.T2 = SIMDES.T2B;
INPUT.woff = SIMDES.woff;
[LINEVAL,err] = func(LINEVAL,INPUT);
if err.flag
    return
end
lineshapeval = LINEVAL.lineshapeval;
satratefunc = @(w1) w1^2*pi*lineshapeval;

%---------------------------------------------
% Setup DE
%---------------------------------------------
INPUT.M0B = SIMDES.relM0B;
INPUT.T1A = SIMDES.T1A;
INPUT.T1B = SIMDES.T1B;
INPUT.T2A = SIMDES.T2A;
INPUT.T2B = SIMDES.T2B;
INPUT.T2B = SIMDES.T2B;
INPUT.EXR = SIMDES.ExchgRate;
INPUT.w1 = SIMDES.w1;
INPUT.woff = SIMDES.woff;
INPUT.satratefunc = satratefunc;
defunc = str2func([SIMDES.coupledblochfunc,'_DE']);
de = @(t,M) defunc(t,M,BLOCH,INPUT);

%---------------------------------------------
% Solve DE
%---------------------------------------------
t = (0:segdur:tauRF);
M0 = [1 SIMDES.relM0B 0 0];
[T,M] = ode45(de,t,M0);

%---------------------------------------------
% Plot
%---------------------------------------------
figure(1); hold on;
plot(T,M(:,1),'r');
plot(T,M(:,3),'g');
plot(T,M(:,4),'c');
ylabel('MA');
xlabel('RF pulse duration (ms)');

figure(2); hold on;
plot(T,M(:,2),'r');
ylabel('MB');
xlabel('RF pulse duration (ms)');

