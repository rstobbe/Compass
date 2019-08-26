%=========================================================
% 
%=========================================================

function [CASL,err] = pCASL_Tagging_v1b_Func(CASL,INPUT)

Status2('busy','Simulate pCASL Tagging',2);
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
%test = max(imag(RF))
RF = real(RF);

%---------------------------------------------
% Bandwidth and Gradient
%---------------------------------------------
BW = (Pars.excitewidth)/CASL.rftau;                                 % in kHz
G = BW/(CASL.excitewid*gamma);                                      % in mT/m

%---------------------------------------------
% Cover Entirety of RF Profile
%---------------------------------------------
fulltestwid = CASL.excitewid*1.2;

%---------------------------------------------
% w1 Calculation
%---------------------------------------------
integral = sum(real(RF))/length(RF);
w1 = (1/integral)*(pi*CASL.rffa/180)/CASL.rftau;                    % in rad/ms
rftime = linspace(0,CASL.rftau,length(RF));

%---------------------------------------------
% Flow Related
%---------------------------------------------
timeinslab = 1000*fulltestwid/NMRPrms.vel;                      % in ms

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
segments = ceil(timeinslab/timeseg);

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
    woffarr = -2*pi*posarr*G*gamma;                             % in rad/ms
    woff(m) = woffarr(1);                                       % for checking
    
    INPUT.woff = woffarr;
    INPUT.w1 = w1*ones(size(woffarr));
    INPUT.time = linspace(0,CASL.rftau,length(RF));
    t = linspace(0,CASL.rftau,100);
    func = @(t,M) simfunc(t,M,SIM,INPUT);
    [t,M] = ode45(func,t,M);    
    Mout = cat(1,Mout,M(2:end,:));
    M = M(100,:);
    m = m+1;
    pos(m) = posarr(end);
    
    %---------------------------------------------
    % Delay
    %---------------------------------------------
    posarr2 = posarr(end) + NMRPrms.vel*deltime/1000;
    woffarr2 = -2*pi*posarr2*G*gamma;                             % in rad/ms
    woff(m) = woffarr2(1);                                       % for checking    

    INPUT.woff = zeros(size(woffarr));
    INPUT.w1 = zeros(size(woffarr));
    INPUT.time = linspace(0,delay,length(RF));
    t = linspace(0,delay,100);
    func = @(t,M) simfunc(t,M,SIM,INPUT);
    [t,M] = ode45(func,t,M);    
    Mout = cat(1,Mout,M(2:end,:));
    M = M(100,:);
    m = m+1;
    pos(m) = posarr2(end);
    
    Status2('busy',num2str(n),3);    
end

%---------------------------------------------
% Plot
%---------------------------------------------
figure(900)
plot(pos)
figure(901)
plot(woff)

%---------------------------------------------
% Plot
%---------------------------------------------
tvec = linspace(0,timeinslab,length(Mout));
figure(1000); hold on;
plot(tvec,squeeze(Mout(:,1)),'b');
plot(tvec,squeeze(Mout(:,2)),'r');
plot(tvec,squeeze(Mout(:,3)),'g');
ylim([-1 1]);
xlabel('Time in Excitation Window (ms)');
ylabel('Relative Magnetic Moment');
error();

%---------------------------------------------
% Plot
%---------------------------------------------
l = 0.79;
h1 = figure(1); 
set(h1,'Renderer','ZBuffer');
hold on;
m = 1;

%Mout(1,1) = 0;
%Mout(1,2) = 0;
%Mout(1,3) = 1;

for n = 1:30:length(Mout)
    plot3([0 squeeze(Mout(n,2))*l],[0 Mout(n,3)*l],[0 Mout(n,1)*l],'r','linewidth',4);
    [U,V,W] = meshgrid([0 Mout(n,2)],[0 Mout(n,3)],[0 Mout(n,1)]);
    [X,Y,Z] = meshgrid([Mout(n,2)*l Mout(n,2)*l],[Mout(n,3)*l Mout(n,3)*l],[Mout(n,1)*l Mout(n,1)*l]);
    h = coneplot(X,Y,Z,X,Y,Z,0.3,'nointerp');
    set(h,'facecolor','r','edgecolor','none');
    set(h,'facelighting','phong');
    light;

    plot3([-1 1],[0 0],[0 0],'k','linewidth',2);
    plot3([0 0],[-1 1],[0 0],'k','linewidth',2);
    plot3([0 0],[0 0],[-1 1],'k','linewidth',2);
    axis([-1 1 -1 1 -1 1]);
    %set(gca,'cameraposition',[6 -16 3]);
    set(gca,'cameraposition',[1 -3 16]);
    set(gca,'cameraposition',[12 -11 6]);
    set(gca,'xticklabel',[],'yticklabel',[],'zticklabel',[]);
    set(gca,'xtick',[],'ytick',[],'ztick',[]);
    set(gca,'box','off');
    grid off;
    axis off;    
    set(h1,'color','w');

    b1vectors = 1;
    if b1vectors == 1
        Vwoff = woff(ceil(n/100))/max(woff); 
        Vw1 = CASL.w1/max(woff); 
        l2 = 0.5;
        plot3([0 Vw1*l2],[0 0],[0 Vwoff*l2],'g','linewidth',4);
        [U,V,W] = meshgrid([0 Vw1],[0 0],[0 Vwoff*l]);
        [X,Y,Z] = meshgrid([Vw1*l2 Vw1*l2],[0 0],[Vwoff*l2 Vwoff*l2]);
        h = coneplot(X,Y,Z,X,Y,Z,0.3,'nointerp');
        set(h,'facecolor','g','edgecolor','none');
        set(h,'facelighting','phong');
        light;
 
        plot3([0 0],[0 0],[0 Vwoff*l2],'b','linewidth',4);
        [U,V,W] = meshgrid([0 0],[0 0],[0 Vwoff*l]);
        [X,Y,Z] = meshgrid([0 0],[0 0],[Vwoff*l2 Vwoff*l2]);
        h = coneplot(X,Y,Z,X,Y,Z,0.3,'nointerp');
        set(h,'facecolor','b','edgecolor','none');
        set(h,'facelighting','phong');
        light;        

        plot3([0 Vw1*l2],[0 0],[0 0],'b','linewidth',4);
        [U,V,W] = meshgrid([0 Vw1*l2],[0 0],[0 0]);
        [X,Y,Z] = meshgrid([Vw1*l2 Vw1*l2],[0 0],[0 0]);
        h = coneplot(X,Y,Z,X,Y,Z,0.3,'nointerp');
        set(h,'facecolor','b','edgecolor','none');
        set(h,'facelighting','phong');
        light;           
        
    end    
 
    m = m+1;
    F(m) = getframe(h1);
    [X,~] = frame2im(F(m));
    X1(:,:,:,m) = rgb2ind(X,[gray(128);jet(128)]);
    clf(h1);
    h1 = figure(1); 
    set(h1,'Renderer','ZBuffer');
    hold on;   
end

size(X1)
imwrite(X1,[gray(128);jet(128)],'ASL_Inversion.gif','gif','LoopCount',1,'DelayTime',0.05);

%--------------------------------------------
% Panel
%--------------------------------------------
Panel(1,:) = {'','','Output'};
CASL.PanelOutput = cell2struct(Panel,{'label','value','type'},2);

