%=========================================================
% 
%=========================================================

function [CASL,err] = pCASL_Tagging2inhomo_v1f_Func(CASL,INPUT)

Status2('busy','pCASL Tagging Sequence',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
NMRPrms = INPUT.NMRPrms;
SIM = CASL.SIM;
gamma = 42.577;
clear INPUT

%---------------------------------------------
% Load Waveform
%---------------------------------------------
[RF,Pars,err] = Load_RFV_v1a(CASL.RFfile);
RF = RF/max(RF);
if max(imag(RF)) > 1e-12
    error();
end
RF = real(RF);

%---------------------------------------------
% Bandwidth and Gradient
%---------------------------------------------
BW = (Pars.excitewidth)/CASL.rftau;                                 % in kHz
G = CASL.gss;
CASL.excitewid = BW/(G*gamma);                                         % in m

%---------------------------------------------
% Duty Cycle
%---------------------------------------------
delay = CASL.rftau*100/CASL.dutycycle - CASL.rftau;
deltime = linspace(0,delay,length(RF));
timeseg = CASL.rftau + delay;
check = CASL.rftau/timeseg;
if check ~= CASL.dutycycle/100
    error()
end

%---------------------------------------------
% w1 Calculation
%---------------------------------------------
integral = sum(real(RF))/length(RF);
w1 = (1/integral)*(pi*CASL.rffa/180)/CASL.rftau;                    % in rad/ms
rftime = linspace(0,CASL.rftau,length(RF));

%--------------------------------------------
% Power Calc
%--------------------------------------------
RelPower = CASL.dutycycle*round(sum(w1*abs(RF).^2));

%---------------------------------------------
% Refocussing
%---------------------------------------------
refgrad = (G*CASL.rftau + CASL.gave)/delay;                      
CASL.SSaref = (refgrad*delay)/(G*CASL.rftau);    

%---------------------------------------------
% Cover Entirety of RF Profile
%---------------------------------------------
fulltestwid = CASL.simulationwid;
if fulltestwid < CASL.excitewid
    err.flag = 1;
    err.msg = 'Simulation Width Must be Larger than Excitation Width';
    return
end

%---------------------------------------------
% Duration and Simulation Segments
%---------------------------------------------
timeinslab = 1000*CASL.excitewid/NMRPrms.vel;                       % in ms
timeinsim = 1000*fulltestwid/NMRPrms.vel;                           % in ms
segments = ceil(timeinsim/timeseg);

%---------------------------------------------
% Initialize Constants
%---------------------------------------------
INPUT.T1 = NMRPrms.T1;
INPUT.T2 = NMRPrms.T2;
simfunc = str2func([CASL.simfunc,'_DE']);

%---------------------------------------------
% Simulate
%---------------------------------------------
M = [1 0 0];
Mout = M;
m = 1;
pos(m) = -fulltestwid/2;
for n = 1:segments

    %---------------------------------------------
    % RF Pulse
    %---------------------------------------------
    posarr = pos(m) + NMRPrms.vel*rftime/1000;
    woffarr = 2*pi*gamma*(posarr*(-G-CASL.delg)) + 2*pi*(-CASL.delb0/1000);       	 % in rad/ms
    woff(m) = woffarr(1);                                             	 % for checking
    
    INPUT.woff = woffarr;
    sign(n) = 1;
    if strcmp(CASL.TagControl,'Control')
        if mod(n,2)
            sign(n) = -1;
        else
            sign(n) = 1;
        end
    end
    %INPUT.w1 = sign(n)*w1*ones(size(woffarr));
    INPUT.w1 = sign(n)*w1*RF;
    INPUT.time = linspace(0,CASL.rftau,length(RF));
    t = (0:0.01:CASL.rftau);
    func = @(t,M) simfunc(t,M,SIM,INPUT);
    [t,M] = ode45(func,t,M);    
    Mout = cat(1,Mout,M(2:end,:));
    M = M(length(t),:);
    m = m+1;
    pos(m) = posarr(end);
    
    %---------------------------------------------
    % Delay
    %---------------------------------------------
    posarr2 = posarr(end) + NMRPrms.vel*deltime/1000;                    
    woffarr2 = 2*pi*gamma*(posarr2*(refgrad-CASL.delg)) + 2*pi*(-CASL.delb0/1000);           % in rad/ms
    woff(m) = woffarr2(1);                                                      % for checking    

    INPUT.woff = woffarr2;
    INPUT.w1 = zeros(size(woffarr));
    INPUT.time = linspace(0,delay,length(RF));
    t = (0:0.01:delay);
    func = @(t,M) simfunc(t,M,SIM,INPUT);
    [t,M] = ode45(func,t,M);    
    Mout = cat(1,Mout,M(2:end,:));
    M = M(length(t),:);
    m = m+1;
    pos(m) = posarr2(end);
    
    Status2('busy',num2str(n),3);    
end

%---------------------------------------------
% Plot
%---------------------------------------------
% figure(900)
% plot(pos)
% figure(901)
% plot(woff)
%test = sign

%---------------------------------------------
% Plot
%---------------------------------------------
tvec = linspace(0,timeinsim,length(Mout));
figure(1000); hold on;
plot(tvec,squeeze(Mout(:,2)),'r');
plot(tvec,squeeze(Mout(:,3)),'g');
plot(tvec,squeeze(Mout(:,1)),'b');
ylim([-1 1]);
xlabel('Time in Excitation Window (ms)');
ylabel('Relative Magnetic Moment');

%---------------------------------------------
% Plot
%---------------------------------------------
zvec = tvec*NMRPrms.vel/1000;
zvec = zvec - (max(zvec)/2);
figure(1001); hold on;
plot(zvec,squeeze(Mout(:,2)),'r');
plot(zvec,squeeze(Mout(:,3)),'g');
plot(zvec,squeeze(Mout(:,1)),'b');
ylim([-1 1]);
xlabel('z Location (m)');
ylabel('Relative Magnetic Moment');

%---------------------------------------------
% Efficiency
%---------------------------------------------
%CASL.Eff = (1-Mout(end,1))/2;              % measure at 250 ms past after tagging plane

%--------------------------------------------
% Return
%--------------------------------------------
CASL.w1 = w1;
CASL.RFshape = Pars.Name;
CASL.RelPower = RelPower;
CASL.BW = BW;
CASL.G = G;
CASL.refgrad = refgrad;
CASL.timeinslab = timeinslab;
CASL.timeinsim = timeinsim;
CASL.T = tvec;
CASL.Marr = Mout;
CASL.delaybetweenRF = delay;

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'RF_FA (deg)',num2str(CASL.rffa),'Output'};
Panel(2,:) = {'RF_tau (ms)',num2str(CASL.rftau),'Output'};
Panel(3,:) = {'RF_file',CASL.RFshape,'Output'};
Panel(4,:) = {'w1 (rad/ms)',num2str(CASL.w1),'Output'};
Panel(5,:) = {'Duty Cycle (%)',num2str(CASL.dutycycle),'Output'};
Panel(6,:) = {'Rel Power',num2str(CASL.RelPower),'Output'};
Panel(7,:) = {'ExciteWid (m)',num2str(CASL.excitewid),'Output'};
Panel(8,:) = {'BW (kHz)',num2str(CASL.BW),'Output'};
Panel(9,:) = {'G (mT/m)',num2str(CASL.G),'Output'};
Panel(10,:) = {'Gref (mT/m)',num2str(CASL.refgrad),'Output'};
Panel(11,:) = {'Delay Between RF (ms)',num2str(CASL.delaybetweenRF),'Output'};
Panel(12,:) = {'Refocus Length (ms)','full time during delay between RF','Output'};
Panel(13,:) = {'SSaref',num2str(CASL.SSaref),'Output'};
%Panel(14,:) = {'Eff',num2str(CASL.Eff),'Output'};

Panel(14,:) = {'','','Output'};
Panel(15,:) = {'SimulationWid (m)',num2str(CASL.simulationwid),'Output'};
Panel(16,:) = {'TimeInSim (ms)',num2str(CASL.timeinsim),'Output'};
Panel(17,:) = {'TimeInSlab (ms)',num2str(CASL.timeinslab),'Output'};



CASL.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

Status2('done','',2);
Status2('done','',3);