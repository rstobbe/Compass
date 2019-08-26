%=========================================================
% 
%=========================================================

function [SIMDES,err] = MzLossSingleRF_v1a_Func(SIMDES,INPUT)

Status('busy','Mz Loss During Single RF pulse');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
BLOCHEX = INPUT.BLOCHEX;
clear INPUT

%---------------------------------------------
% Get Variables
%---------------------------------------------
tauRF = SIMDES.tauRF;
segdur = BLOCHEX.segdur;
defunc = str2func([SIMDES.blochexcitefunc,'_DE']);

%---------------------------------------------
% Setup DE
%---------------------------------------------
INPUT.T1 = SIMDES.T1;
INPUT.T2 = SIMDES.T2;
INPUT.w1 = SIMDES.w1;
INPUT.woff = SIMDES.woff;
de = @(t,M) defunc(t,M,BLOCHEX,INPUT);

%---------------------------------------------
% Solve DE
%---------------------------------------------
t = (0:segdur:tauRF);
M0 = [1 0 0];
[T,M] = ode45(de,t,M0);

%---------------------------------------------
% Plot
%---------------------------------------------
figure(1); hold on;
plot(T,M(:,1),'r');
plot(T,M(:,2),'b');
plot(T,M(:,3),'g');
ylabel('Mz');
xlabel('RF pulse duration (ms)');

