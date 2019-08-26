%====================================================
%  
%====================================================

function [TST,err] = Anlz_RFwfmV_v1b_Func(INPUT,TST)

Status('busy','Analyze RF waveforem');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
RFfile = INPUT.RFfile;
%BLOCH = INPUT.BLOCH;
clear INPUT;
plotbw = TST.plotbw;
flip = TST.flipangle;
pw = TST.pulsedur/1000;

%---------------------------------------------
% Load Waveform
%---------------------------------------------
[RF,Pars,err] = Load_RFV_v1a(RFfile);
RF = RF/max(RF);
time = linspace(0,pw,length(RF));

%---------------------------------------------
% w1 Calculation
%---------------------------------------------
integral = sum(real(RF))/length(RF);
w1 = (1/integral)*((pi*flip/180)/pw);

%---------------------------------------------
% Plot
%---------------------------------------------
figure(100); hold on;
plot(time*1000,real(RF),'r');
plot(time*1000,imag(RF),'b');
xlabel('ms');
ylabel('Relative');
title('Relative RF pulse shape');

figure(101); hold on;
plot(time*1000,w1*real(RF),'r');
plot(time*1000,w1*imag(RF),'b');
xlabel('ms');
ylabel('rad/ms');
title('RF pulse amplitude');

%---------------------------------------------
% Power
%---------------------------------------------
RelPower = round(sum(w1*abs(RF).^2));

%---------------------------------------------
% Simulate
%---------------------------------------------
INPUT.time = time;
INPUT.w1 = w1*RF;
INPUT.T1 = 1e6;
INPUT.T2 = 1e6;
blochfunc = str2func([TST.blochfunc,'_DE']);
woff = 2*pi*linspace(0,plotbw,100);
for n = 1:length(woff)
    M = [1;0;0];
    INPUT.woff = woff(n)*ones(size(RF));
    func = @(t,M) blochfunc(t,M,'',INPUT);
    [t,Mint] = ode45(func,[0 pw],M);
    Mout(n,:) = Mint(length(Mint(:,1)),:);
end
M = Mout(:,2) + 1i*Mout(:,3);

%---------------------------------------------
% Plot
%---------------------------------------------
figure(300); hold on;
plot(woff/(2*pi),abs(M)); 
xlabel('Hz');
title(['Abs Profile for a ',num2str(flip),'o pulse']);
ylim([0 1.1*max(abs(M(:)))]);

figure(301); hold on;
%plot(woff/(2*pi),unwrap(angle(M))); 
plot(woff/(2*pi),angle(M));
xlabel('Hz');
ylabel('Radians');
title(['Phase Profile for a ',num2str(flip),'o pulse']);
ylim([-pi pi]);

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'Integral',integral,'Output'};
Panel(2,:) = {'RelPower',RelPower,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
TST.PanelOutput = PanelOutput;

%---------------------------------------------
% Return
%---------------------------------------------
TST.time = time;
TST.RF = RF;
TST.woff = woff;
TST.M = M;
TST.integral = integral;
TST.RelPower = RelPower;

Status('done','');
Status2('done','',2);
Status2('done','',3);

