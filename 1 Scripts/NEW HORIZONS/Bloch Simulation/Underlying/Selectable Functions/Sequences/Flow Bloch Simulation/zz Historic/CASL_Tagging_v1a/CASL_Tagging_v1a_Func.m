%=========================================================
% 
%=========================================================

function [CASL,err] = CASL_Tagging_v1a_Func(CASL,INPUT)

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
CASL.w1 = (pi*CASL.rffa/180)/CASL.rftau;                    % in rad/ms

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

