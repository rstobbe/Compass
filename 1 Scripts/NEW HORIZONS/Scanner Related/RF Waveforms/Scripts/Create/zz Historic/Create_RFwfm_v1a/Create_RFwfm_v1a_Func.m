%====================================================
%  
%====================================================

function [RF,err] = Create_RFwfm_v1a_Func(INPUT,RF)

Status('busy','Create RF Waveform');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
SIM = INPUT.SIM;
clear INPUT;

%---------------------------------------------
% Create 'Beta' Polynomial (SLR) - John Pauly 
%---------------------------------------------
if strcmp(RF.type,'Ex') || strcmp(RF.type,'Ref')
    b = dzls(RF.slvpts,RF.tbwprod,RF.ripin,RF.ripout);
elseif strcmp(RF.type,'MinPh') || strcmp(RF.type,'MinPh')
    b = real(RWS_dzmp(RF.slvpts,RF.tbwprod,RF.ripin,RF.ripout));   
    if strcmp(RF.type,'MinPh')
        b = flipdim(b,2);
    end
end

%---------------------------------------------
% Scale for Tip Angle
%---------------------------------------------
b = b*sin(pi*(RF.flip/2)/180);              % see Pauly - proportional to sin(flip/2)
%figure(100); hold on; plot(b,'r');
%title('a and b polynomials');

%---------------------------------------------
% Observe FT
%---------------------------------------------
%bzf = b;
%bzf(8*length(b)) = 0;
%B = fft(bzf);
%figure(101); hold on; plot(abs(B),'r');
%absA = sqrt(1-B.*conj(B));                  % Pauly (17)
%figure(101); hold on;plot(absA,'g');        % green in plot should be covered by blue of abs(A) below      

%---------------------------------------------
% Compute Minimum Phase 'Alpha' Polynomial - John Pauly
%---------------------------------------------
a = b2a(b);
%test = sum(imag(a));                        % should be real (if b is real I guess)
a = real(a);
%figure(100); hold on; plot(a,'b');
%title('a and b polynomials');

%---------------------------------------------
% Test FT
%---------------------------------------------
%azf = a;
%azf(8*length(a)) = 0;
%A = fft(azf);
%figure(101); hold on; plot(abs(A),'b');

%---------------------------------------------
% Inverse SLR - John Pauly
%---------------------------------------------
wfm = real(ab2rf(a,b));
wfm = wfm/max(wfm);
figure(102); hold on; plot(wfm,'k');

%---------------------------------------------
% Integral Calculation
%---------------------------------------------
integral = sum(wfm)/length(wfm);
RelPower = round(sum(((1/integral)*abs(wfm)).^2));

%---------------------------------------------
% Simulate
%---------------------------------------------
func = str2func([RF.simfunc,'_Func']);
INPUT.wfm = wfm;
INPUT.flip = RF.flip;
INPUT.simhbw = RF.tbwprod;
[SIM,err] = func(SIM,INPUT);
if err.flag
    return
end
clear INPUT

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

%---------------------------------------------
% Simulate
%---------------------------------------------
INPUT.time = time;
INPUT.w1 = w1*RF;
INPUT.T1 = 1e6;
INPUT.T2 = 1e6;
blochfunc = str2func([RF.blochfunc,'_DE']);
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
RF.PanelOutput = PanelOutput;

%---------------------------------------------
% Return
%---------------------------------------------
RF.time = time;
RF.RF = RF;
RF.woff = woff;
RF.M = M;
RF.integral = integral;
RF.RelPower = RelPower;

Status('done','');
Status2('done','',2);
Status2('done','',3);

