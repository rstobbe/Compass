%====================================================
%  
%====================================================

function [SIM,err] = Sim_RFwfm_v1a_Func(SIM,INPUT)

Status2('busy','Simulate RF Waveform',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
wfm = INPUT.wfm;
flip = INPUT.flip;
simhbw = INPUT.simhbw;
%BLOCH = INPUT.BLOCH;
clear INPUT;

%---------------------------------------------
% w1 Calculation
%---------------------------------------------
pw = 1;
time = linspace(0,pw,length(wfm));
integral = sum(real(wfm))/length(wfm);
w1 = (1/integral)*((pi*flip/180)/pw);

%---------------------------------------------
% Simulate
%---------------------------------------------
INPUT.time = time;
INPUT.w1 = w1*wfm;
INPUT.T1 = 1e6;
INPUT.T2 = 1e6;
blochfunc = str2func([SIM.blochfunc,'_DE']);
woff = 2*pi*linspace(0,simhbw,100);
for n = 1:length(woff)
    M = [1;0;0];
    INPUT.woff = woff(n)*ones(size(wfm));
    func = @(t,M) blochfunc(t,M,'',INPUT);
    [t,Mint] = ode45(func,[0 pw],M);
    Mout(n,:) = Mint(length(Mint(:,1)),:);
    Status2('busy',num2str(n),3);
end
M = Mout(:,2) + 1i*Mout(:,3);

%---------------------------------------------
% Plot
%---------------------------------------------
figure(300); hold on;
plot(woff/(2*pi),abs(M)); 
xlabel('Time-Bandwidth (half BW shown)');
title(['Abs Profile for a ',num2str(flip),'o pulse']);
ylim([0 1.1*max(abs(M(:)))]);

figure(301); hold on;
%plot(woff/(2*pi),unwrap(angle(M))); 
plot(woff/(2*pi),angle(M));
xlabel('Time-Bandwidth (half BW shown)');
ylabel('Radians');
title(['Phase Profile for a ',num2str(flip),'o pulse']);
ylim([-pi pi]);

%---------------------------------------------
% Return
%---------------------------------------------
SIM.tbw = woff/(2*pi);
SIM.M = M;

Status2('done','',2);
Status2('done','',3);

