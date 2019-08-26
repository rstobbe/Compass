%=========================================================
% 
%=========================================================

function [CASL,err] = CASL_Tagging_v1b_Func(CASL,INPUT)

Status2('busy','Simulate CASL Tagging',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
NMRPrms = INPUT.NMRPrms;
SIM = CASL.SIM;
clear INPUT

%---------------------------------------------
% Seq Parameters
%---------------------------------------------
CASL.w1 = pi*CASL.rfdegpms/180;

%---------------------------------------------
% Initialize Constants
%---------------------------------------------
segments = 100;
INPUT.T1 = NMRPrms.T1;
INPUT.T2 = NMRPrms.T2;
INPUT.w1 = [CASL.w1 CASL.w1];
simfunc = str2func([CASL.simfunc,'_DE']);
timeinslice = 1000*CASL.excitewid/NMRPrms.vel;              % in ms
timeseg = timeinslice/segments;
INPUT.time = [0 timeseg];
gamma = 42.577;

%---------------------------------------------
% Segment
%---------------------------------------------
M = [1 0 0];
Mout = M;
for n = 1:segments
    pos(n) = -CASL.excitewid/2 + NMRPrms.vel*timeseg*(n-1)/1000;
    woff(n) = -2*pi*pos(n)*CASL.grad*gamma;                       % in rad/ms
    INPUT.woff = [woff(n) woff(n)];
    t = linspace(0,timeseg,100);
    func = @(t,M) simfunc(t,M,SIM,INPUT);
    [t,M] = ode45(func,t,M);    
    Mout = cat(1,Mout,M(2:end,:));
    M = M(100,:);
    Status2('busy',num2str(n),3);
end

%---------------------------------------------
% Plot
%---------------------------------------------
tvec = linspace(0,timeinslice,9901);
figure(1000); hold on;
plot(tvec,squeeze(Mout(:,1)),'b');
plot(tvec,squeeze(Mout(:,2)),'r');
plot(tvec,squeeze(Mout(:,3)),'g');
ylim([-1 1]);
xlabel('Time in Excitation Window (ms)');
ylabel('Relative Magnetic Moment');

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'','','Output'};
CASL.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

