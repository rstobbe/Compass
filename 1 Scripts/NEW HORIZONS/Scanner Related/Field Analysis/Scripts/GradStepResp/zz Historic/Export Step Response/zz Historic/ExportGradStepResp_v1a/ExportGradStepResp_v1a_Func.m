%==================================================
% 
%==================================================

function [OUTPUT,err] = ExportGradStepResp_v1a_Func(SR,INPUT)

Status('busy','Plot Step Response');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
OUTPUT = struct();

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
GRD = INPUT.GRD;
TGFX = INPUT.TGFX;
TGFY = INPUT.TGFY;
TGFZ = INPUT.TGFZ;
clear INPUT

%-----------------------------------------------------
% Test to Make Sure 'TGFs' Same...
%-----------------------------------------------------

%-----------------------------------------------------
% Get Variables
%-----------------------------------------------------
Tstep = SR.Tstep;
Tmax = SR.Tmax;

%-----------------------------------------------------
% Get Gradient Info
%-----------------------------------------------------
L0 = GRD.L;
Gvis0 = GRD.Gvis;
initfinaldecay = GRD.pregdur + GRD.gatmaxdur*2 + GRD.intergdur;
gmax = max(Gvis0,[],2);
ngrads = length(Gvis0(:,1));

%-----------------------------------------------------
% Get Transient Field Info
%-----------------------------------------------------
Time0 = TGFX.Time;
GeddyX0 = TGFX.Geddy;
GeddyY0 = TGFY.Geddy;
GeddyZ0 = TGFZ.Geddy;

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
figure(1000); hold on; 
plot([0 max(Time0)],[0 0],'k:'); 
plot(Time0,GeddyX0,'r');
plot(L0,Gvis0,'k');
xlim([initfinaldecay-0.1 initfinaldecay + 0.5]);
ylim([-max(gmax)-1 1]);
xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); title('X');

figure(1001); hold on; 
plot([0 max(Time0)],[0 0],'k:'); 
plot(Time0,GeddyY0,'b');
plot(L0,Gvis0,'k');
xlim([initfinaldecay-0.1 initfinaldecay + 0.5]);
ylim([-max(gmax)-1 1]);
xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); title('Y');

figure(1002); hold on; 
plot([0 max(Time0)],[0 0],'k:'); 
plot(Time0,GeddyZ0,'g');
plot(L0,Gvis0,'k');
xlim([initfinaldecay-0.1 initfinaldecay + 0.5]);
ylim([-max(gmax)-1 1]);
xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); title('Z');

%-----------------------------------------------------
% Interpolate and Segment
%-----------------------------------------------------
Geddy0 = cat(3,GeddyX0,GeddyY0,GeddyZ0);
Time = (0:Tstep:Tmax);
Geddy0 = permute(Geddy0,[2 1 3]);
Geddy = interp1(Time0,Geddy0,initfinaldecay+Time);
Geddy = permute(Geddy,[2 1 3]);

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
figure(2000); hold on; 
plot([0 max(Time)],[0 0],'k:'); 
plot(Time,Geddy(:,:,1),'r');
figure(2001); hold on; 
plot([0 max(Time)],[0 0],'k:'); 
plot(Time,Geddy(:,:,2),'b');
figure(2002); hold on; 
plot([0 max(Time)],[0 0],'k:'); 
plot(Time,Geddy(:,:,3),'g');

%-----------------------------------------------------
% Calculate Slopes
%-----------------------------------------------------
%gmax = permute(gmax,[2 1]);
for m = 1:3
    for n = 1:ngrads
        bT95(n,m) = interp1(Geddy(n,:,m),Time,-gmax(n)*0.95);
        bT90(n,m) = interp1(Geddy(n,:,m),Time,-gmax(n)*0.90);
        bT85(n,m) = interp1(Geddy(n,:,m),Time,-gmax(n)*0.85);
        bT80(n,m) = interp1(Geddy(n,:,m),Time,-gmax(n)*0.80);
        tT05(n,m) = interp1(Geddy(n,:,m),Time,-gmax(n)*0.05);
        tT10(n,m) = interp1(Geddy(n,:,m),Time,-gmax(n)*0.10);
        tT15(n,m) = interp1(Geddy(n,:,m),Time,-gmax(n)*0.15);
        tT20(n,m) = interp1(Geddy(n,:,m),Time,-gmax(n)*0.20);
    end
    slope90(:,m) = (0.9*gmax)./(tT05(:,m) - bT95(:,m));
    slope80(:,m) = (0.8*gmax)./(tT10(:,m) - bT90(:,m));  
    slope70(:,m) = (0.7*gmax)./(tT15(:,m) - bT85(:,m));  
    slope60(:,m) = (0.6*gmax)./(tT20(:,m) - bT80(:,m));  
end
figure(3000); hold on
plot(gmax,slope90(:,1),'r'); plot(gmax,slope80(:,1),'r--'); plot(gmax,slope70(:,1),'r-.'); plot(gmax,slope60(:,1),'r:');   
plot(gmax,slope90(:,2),'b'); plot(gmax,slope80(:,2),'b--'); plot(gmax,slope70(:,2),'b-.'); plot(gmax,slope60(:,2),'b:');  
plot(gmax,slope90(:,3),'g'); plot(gmax,slope80(:,3),'g--'); plot(gmax,slope70(:,3),'g-.'); plot(gmax,slope60(:,3),'g:');  

%-----------------------------------------------------
% Normalize
%-----------------------------------------------------
for m = 1:3
    for n = 1:ngrads
        Geddy(n,:,m) = Geddy(n,:,m)/Geddy(n,1,m);
    end
end

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
figure(4000); hold on; 
plot([0 max(Time)],[0 0],'k:'); 
plot(Time,Geddy(:,:,1),'r');
plot(Time,Geddy(1,:,1),'k');
figure(4001); hold on; 
plot([0 max(Time)],[0 0],'k:'); 
plot(Time,Geddy(:,:,2),'b');
plot(Time,Geddy(1,:,2),'k');
figure(4002); hold on; 
plot([0 max(Time)],[0 0],'k:'); 
plot(Time,Geddy(:,:,3),'g');
plot(Time,Geddy(1,:,3),'k');

%-----------------------------------------------------
% Return
%-----------------------------------------------------
SR.t = Time;
SR.step = SR.Tstep;
SR.T = SR.Tmax;
SR.N = length(t);
%SR.Gmax = ;
SR.Ginc = GRD.gstep;
SR.Gmin = GRD.gstart;
SR.graddel = graddel;

%===============================================
function OutStyle
outstyle = 0;
if outstyle == 1
    set(gcf,'units','inches');
    set(gcf,'position',[4 4 4 4]);
    set(gcf,'paperpositionmode','auto');
    set(gca,'units','inches');
    set(gca,'position',[0.75 0.5 2.5 2.5]);
    set(gca,'fontsize',10,'fontweight','bold');
    box on;
end