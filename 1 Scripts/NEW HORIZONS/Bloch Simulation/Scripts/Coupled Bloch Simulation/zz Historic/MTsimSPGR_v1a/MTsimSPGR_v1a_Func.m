%=========================================================
% 
%=========================================================

function [SIMDES,err] = MTsim_v1a_Func(SIMDES,INPUT)

Status('busy','MT Simulation');
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
% Common Variables;
%---------------------------------------------
TR = SIMDES.TR;

%---------------------------------------------
% Build Saturation Rate Function
%---------------------------------------------
func = str2func([SIMDES.linevalfunc,'_Func']);  
INPUT.T2 = SIMDES.T2B;
INPUT.woff = SIMDES.satrfwoff;
[LINEVAL,err] = func(LINEVAL,INPUT);
if err.flag
    return
end
lineshapeval = LINEVAL.lineshapeval;
satratefunc = @(w1) w1^2*pi*lineshapeval;

%---------------------------------------------
% Setup DE for Sat Pulse
%---------------------------------------------
SatPulseN = 10;
SATINPUT.M0B = SIMDES.relM0B;
SATINPUT.T1A = SIMDES.T1A;
SATINPUT.T1B = SIMDES.T1B;
SATINPUT.T2A = SIMDES.T2A;
SATINPUT.T2B = SIMDES.T2B;
SATINPUT.T2B = SIMDES.T2B;
SATINPUT.EXR = SIMDES.ExchgRate;
SATINPUT.w1 = (SIMDES.satrffa/360)*(1/SIMDES.satrftau)*1000;
SATINPUT.woff = SIMDES.satrfwoff;
SATINPUT.satratefunc = satratefunc;
func = str2func([SIMDES.coupledblochfunc,'_DE']);
satpulsefunc = @(t,M) func(t,M,BLOCH,SATINPUT);
tsatpulse = linspace(0,SIMDES.satrftau,SatPulseN);

%---------------------------------------------
% Setup DE for Recovery
%---------------------------------------------
RecN = 10;
RECINPUT.M0B = SIMDES.relM0B;
RECINPUT.T1A = SIMDES.T1A;
RECINPUT.T1B = SIMDES.T1B;
RECINPUT.T2A = SIMDES.T2A;
RECINPUT.T2B = SIMDES.T2B;
RECINPUT.T2B = SIMDES.T2B;
RECINPUT.EXR = SIMDES.ExchgRate;
RECINPUT.w1 = 0;
RECINPUT.woff = 0;
RECINPUT.satratefunc = satratefunc;
func = str2func([SIMDES.coupledblochfunc,'_DE']);
recfunc = @(t,M) func(t,M,BLOCH,RECINPUT);
trec = linspace(0,SIMDES.TR-SIMDES.satrftau,RecN);

%---------------------------------------------
% Initial Conditions 
%       - assume first acq = garbage
%       - begin with effect of 90 excitation
%---------------------------------------------
MzA0 = 0;
MzB0 = 0;
MzA = 0;
MzB = 0;
T = 0;

%---------------------------------------------
% Solve Sequence
%---------------------------------------------
for n = 1:Nslices
    M0 = [MzA0 MzB0 0 0];
    [t,M] = ode45(satpulsefunc,tsatpulse,M0);
    MzA0 = M(SatPulseN,1);
    MzB0 = M(SatPulseN,2);
    MzA = [MzA;M(:,1)]; 
    MzB = [MzB;M(:,2)];
    T = [T;t+T(length(T))];
    M0 = [MzA0 MzB0 0 0];
    [t,M] = ode45(recfunc,trec,M0); 
    MzA0 = M(RecN,1);
    MzB0 = M(RecN,2);
    MzA = [MzA;M(:,1)]; 
    MzB = [MzB;M(:,2)];
    T = [T;t+T(length(T))];
    M0 = [MzA0 MzB0 0 0];        
end


%---------------------------------------------
% Plot
%---------------------------------------------
figure(1); hold on;
plot(T,MzA,'r');
ylabel('MA');
xlabel('RF pulse duration (ms)');

figure(2); hold on;
plot(T,MzB,'r');
ylabel('MB');
xlabel('RF pulse duration (ms)');

