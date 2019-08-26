%====================================================
%  
%====================================================

function [TST,err] = Anlz_RFwfmV_v1a_Func(INPUT,TST)

Status('busy','Analyze RF waveforem');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
RFfile = INPUT.RFfile;
clear INPUT;

pw = TST.pulsedur/1000;
%---------------------------------------------
% Load Waveform
%---------------------------------------------
[RF,err] = Load_RFV_v1a(RFfile);
RF = RF/max(RF);
time = linspace(0,pw,length(RF));

%---------------------------------------------
% Plot
%---------------------------------------------
figure(100); hold on;
plot(time*1000,RF);
xlabel('ms');
title('RF pulse shape');

%---------------------------------------------
% Integral Test
%---------------------------------------------
integral = sum(RF)/length(RF);

%---------------------------------------------
% FT Test
%---------------------------------------------
%fmax = 1/(2*time(2))
%bwRF = fftshift(fft(RF));
%freq = (-length(RF)/2*(1/pw)+1:(1/pw):length(RF)/2*(1/pw));

%---------------------------------------------
% Plot
%---------------------------------------------
%figure(101); hold on;
%plot(freq,abs(bwRF),'k');
%xlim([-2000 2000]);
%figure(102); hold on;
%plot(freq,unwrap(angle(bwRF)));
%xlim([-2000 2000]);

INPUT.time = time;
INPUT.w1 = (1/integral)*(pi/(2*pw))*RF;
%INPUT.w1 = (1/integral)*(pi/(1.2*pw))*RF;
INPUT.T1 = 1e6;
INPUT.T2 = 1e6;
blochfunc = str2func('StandardBloch_v1a_DE');
woff = 2*pi*(0:2:500);
for n = 1:length(woff)
    M = [1;0;0];
    INPUT.woff = woff(n);
    func = @(t,M) blochfunc(t,M,'',INPUT);
    [t,Mint] = ode113(func,[0 pw],M);
    %figure(200); hold on;
    %plot(t,Mint);
    Mout(n,:) = Mint(length(Mint(:,1)),:);
end

figure(300); hold on;
plot(woff/(2*pi),sqrt(Mout(:,2).^2 + Mout(:,3).^2)); 
xlabel('Hz');
title('Profile for a 90o pulse');

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'Integral',integral,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
TST.PanelOutput = PanelOutput;

%---------------------------------------------
% Return
%---------------------------------------------
TST.integral = integral;

Status('done','');
Status2('done','',2);
Status2('done','',3);

