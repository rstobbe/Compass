%==================================================
% 
%==================================================

function [SR,err] = ExportGradStepRespRiseFall_v1d_Func(SR,INPUT)

Status('busy','Plot Step Response');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
GRD = INPUT.GRD;
TGFX = INPUT.TGFX;
TGFY = INPUT.TGFY;
TGFZ = INPUT.TGFZ;
clear INPUT

%-----------------------------------------------------
% Test 
%-----------------------------------------------------
if SR.Gmax >= GRD.gstop
    err.flag = 1;
    err.msg = ['Max Grad < ', num2str(GRD.gstop)];
    return
end

%-----------------------------------------------------
% Test to Make Sure 'TGFs' Same...
%-----------------------------------------------------

%-----------------------------------------------------
% Get Variables
%-----------------------------------------------------
graddelchng = SR.graddelchng/1000;
expgraddel = TGFX.TF.Params.graddel/1000;
Tstep = SR.Tstep;
Tmax = SR.Tmax;

%-----------------------------------------------------
% Get Gradient Info
%-----------------------------------------------------
L0 = GRD.L;
Gvis0 = GRD.Gvis;
initfall = GRD.pregdur + GRD.gatmaxdur*2 + GRD.intergdur;
initrise = GRD.pregdur;
gmax = max(Gvis0,[],2);
ngrads = length(Gvis0(:,1));

%-----------------------------------------------------
% Get Transient Field Info
%-----------------------------------------------------
Time0 = TGFX.Time;
GeddyX0 = -TGFX.Geddy;
GeddyY0 = -TGFY.Geddy;
GeddyZ0 = TGFZ.Geddy;

%-----------------------------------------------------
% Adjust Time0  
%   - adjust for graddel adjustment
%-----------------------------------------------------
Time0 = Time0 - graddelchng;

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
doinitplot = 0;
if doinitplot == 1
    figure(1000); hold on; 
    plot([0 max(Time0)],[0 0],'k:'); 
    plot(Time0,GeddyX0,'r');
    plot(L0,Gvis0,'k');
    xlim([initrise-0.1 initrise + 2]);
    ylim([0 max(gmax)+1]);
    xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); title('X');
    figure(1001); hold on; 
    plot([0 max(Time0)],[0 0],'k:'); 
    plot(Time0,GeddyY0,'b');
    plot(L0,Gvis0,'k');
    xlim([initrise-0.1 initrise + 2]);
    ylim([0 max(gmax)+1]);
    xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); title('Y');
    figure(1002); hold on; 
    plot([0 max(Time0)],[0 0],'k:'); 
    plot(Time0,GeddyZ0,'g');
    plot(L0,Gvis0,'k');
    xlim([initrise-0.1 initrise + 2]);
    ylim([0 max(gmax)+1]);
    xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); title('Z');
end

%-----------------------------------------------------
% Find Final Value
%-----------------------------------------------------
ind1 = find(Time0 < initfall - 0.08,1,'last');
%meanstart = Time0(ind1);
ind2 = find(Time0 < initfall - 0.02,1,'last');
%meanstop = Time0(ind2);
GeddyXstart = mean(GeddyX0(:,ind1:ind2),2);
GeddyYstart = mean(GeddyY0(:,ind1:ind2),2);
GeddyZstart = mean(GeddyZ0(:,ind1:ind2),2);

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
Garr = (GRD.gstart:GRD.gstep:GRD.gstop);
figure(1500); hold on;
%plot(Garr,'k');
plot(Garr,GeddyXstart' + Garr,'r');
plot(Garr,GeddyYstart' + Garr,'b');
plot(Garr,GeddyZstart' + Garr,'g');
xlabel('Applied Gradient Magnitude (mT/m)'); ylabel('Gradient Magnitude Error (mT/m)');

%-----------------------------------------------------
% Interpolate and Segment
%-----------------------------------------------------
Geddy0 = cat(3,GeddyX0,GeddyY0,GeddyZ0);
Time = (0:Tstep:Tmax);
Geddy0 = permute(Geddy0,[2 1 3]);
Geddy = interp1(Time0,Geddy0,initrise+Time);
Geddy = permute(Geddy,[2 1 3]);
GeddyFall = interp1(Time0,Geddy0,initfall+Time);
GeddyFall = permute(GeddyFall,[2 1 3]);

%-----------------------------------------------------
% Calculate Slopes
%-----------------------------------------------------
%gmax = permute(gmax,[2 1]);
for m = 1:3
    for n = 1:ngrads
        bT95(n,m) = interp1(Geddy(n,:,m),Time,gmax(n)*0.95);
        bT90(n,m) = interp1(Geddy(n,:,m),Time,gmax(n)*0.90);
        bT85(n,m) = interp1(Geddy(n,:,m),Time,gmax(n)*0.85);
        bT80(n,m) = interp1(Geddy(n,:,m),Time,gmax(n)*0.80);
        tT05(n,m) = interp1(Geddy(n,:,m),Time,gmax(n)*0.05);
        tT10(n,m) = interp1(Geddy(n,:,m),Time,gmax(n)*0.10);
        tT15(n,m) = interp1(Geddy(n,:,m),Time,gmax(n)*0.15);
        tT20(n,m) = interp1(Geddy(n,:,m),Time,gmax(n)*0.20);
    end
    slope90(:,m) = -(0.9*gmax)./(tT05(:,m) - bT95(:,m));
    slope80(:,m) = -(0.8*gmax)./(tT10(:,m) - bT90(:,m));  
    slope70(:,m) = -(0.7*gmax)./(tT15(:,m) - bT85(:,m));  
    slope60(:,m) = -(0.6*gmax)./(tT20(:,m) - bT80(:,m));  
end
figure(3000); hold on
plot(gmax,slope90(:,1),'r'); plot(gmax,slope80(:,1),'r--'); plot(gmax,slope70(:,1),'r-.'); plot(gmax,slope60(:,1),'r:');   
plot(gmax,slope90(:,2),'b'); plot(gmax,slope80(:,2),'b--'); plot(gmax,slope70(:,2),'b-.'); plot(gmax,slope60(:,2),'b:');  
plot(gmax,slope90(:,3),'g'); plot(gmax,slope80(:,3),'g--'); plot(gmax,slope70(:,3),'g-.'); plot(gmax,slope60(:,3),'g:');  
ind = find(gmax > SR.Gmax,1,'first'); 
SlewRate = mean(slope80(ind,:));
if isnan(SlewRate)
    err.flag = 1;
    err.msg = 'Gradient Signs Wrong';
end

%-----------------------------------------------------
% Isolate
%-----------------------------------------------------
ngrads = find(Garr >= SR.Gmax,1,'first');
Geddy = Geddy(1:ngrads,:,:);
GeddyFall = GeddyFall(1:ngrads,:,:);

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
figure(2000); hold on; 
plot([0 max(Time)],[0 0],'k:'); 
plot(Time,Geddy(:,:,1),'r');
plot(Time,GeddyFall(:,:,1),'r:');
figure(2001); hold on; 
plot([0 max(Time)],[0 0],'k:'); 
plot(Time,Geddy(:,:,2),'b');
plot(Time,GeddyFall(:,:,2),'b:');
figure(2002); hold on; 
plot([0 max(Time)],[0 0],'k:'); 
plot(Time,Geddy(:,:,3),'g');
plot(Time,GeddyFall(:,:,3),'g:');

%-----------------------------------------------------
% Find Remaining at End
%-----------------------------------------------------
RemEndX = Garr(1:ngrads)-Geddy(:,length(Time),1)';
RemEndY = Garr(1:ngrads)-Geddy(:,length(Time),2)';
RemEndZ = Garr(1:ngrads)-Geddy(:,length(Time),3)';
RemEndXFall = abs(GeddyFall(:,length(Time),1))';
RemEndYFall = abs(GeddyFall(:,length(Time),2))';
RemEndZFall = abs(GeddyFall(:,length(Time),3))';

%-----------------------------------------------------
% Plot Remaining at End
%-----------------------------------------------------
figure(3001); hold on;
plot(Garr(1:ngrads),RemEndX,'r');
plot(Garr(1:ngrads),RemEndY,'b');
plot(Garr(1:ngrads),RemEndZ,'g');
plot(Garr(1:ngrads),RemEndXFall,'r:');
plot(Garr(1:ngrads),RemEndYFall,'b:');
plot(Garr(1:ngrads),RemEndZFall,'g:');
MaxRemEndX = max(RemEndX);
MaxRemEndY = max(RemEndY);
MaxRemEndZ = max(RemEndZ);
MaxRemEndXFall = max(RemEndXFall);
MaxRemEndYFall = max(RemEndYFall);
MaxRemEndZFall = max(RemEndZFall);
xlabel('Gradient Value (mT/m)'); ylabel('Remaining at End (mT/m)');

%-----------------------------------------------------
% Normalize
%-----------------------------------------------------
for m = 1:3
    for n = 1:ngrads
        Geddy(n,:,m) = Geddy(n,:,m)/Garr(n);
        GeddyFall(n,:,m) = (Garr(n) + GeddyFall(n,:,m))/Garr(n);
    end
end
Geddy(:,length(Geddy(1,:,1)),:) = 1;
GeddyFall(:,length(GeddyFall(1,:,1)),:) = 1;

%-----------------------------------------------------
% Join
%-----------------------------------------------------
ind = find(Time > SR.R2Fswitch,1,'first');
Geddy = cat(2,Geddy(:,1:ind,:),GeddyFall(:,ind+1:length(Time),:));

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
figure(4000); hold on; 
plot([0 max(Time)],[0 0],'k:'); 
plot(Time,GeddyFall(1,:,1),'k');
plot(Time,GeddyFall(round(ngrads/2),:,1),'k');
plot(Time,GeddyFall(ngrads,:,1),'k');
plot(Time,Geddy(1,:,1),'r');
plot(Time,Geddy(round(ngrads/2),:,1),'r');
plot(Time,Geddy(ngrads,:,1),'r');
figure(4001); hold on; 
plot([0 max(Time)],[0 0],'k:'); 
plot(Time,GeddyFall(1,:,2),'k');
plot(Time,GeddyFall(round(ngrads/2),:,2),'k');
plot(Time,GeddyFall(ngrads,:,2),'k');
plot(Time,Geddy(1,:,2),'b');
plot(Time,Geddy(round(ngrads/2),:,2),'b');
plot(Time,Geddy(ngrads,:,2),'b');
figure(4002); hold on; 
plot([0 max(Time)],[0 0],'k:'); 
plot(Time,GeddyFall(1,:,3),'k');
plot(Time,GeddyFall(round(ngrads/2),:,3),'k');
plot(Time,GeddyFall(ngrads,:,3),'k');
plot(Time,Geddy(1,:,3),'g');
plot(Time,Geddy(round(ngrads/2),:,3),'g');
plot(Time,Geddy(ngrads,:,3),'g');

%-----------------------------------------------------
% Return
%-----------------------------------------------------
SR.t = Time;
SR.step = SR.Tstep;
SR.T = SR.Tmax;
SR.N = length(Time);
SR.Ginc = GRD.gstep;
SR.Gmin = GRD.gstart;
SR.GSR = Geddy;
SR.graddel = expgraddel + graddelchng;
SR.SlewRate = SlewRate;

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'RemEndX (mT/m)',num2str(MaxRemEndXFall),'Output'};
Panel(2,:) = {'RemEndY (mT/m)',num2str(MaxRemEndYFall),'Output'};
Panel(3,:) = {'RemEndZ (mT/m)',num2str(MaxRemEndZFall),'Output'};
Panel(4,:) = {'MeanSlewAtGmax',num2str(SR.SlewRate),'Output'};
Panel(5,:) = {'graddel (us)',num2str(SR.graddel*1000),'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
SR.PanelOutput = PanelOutput;


Status('done','');
Status2('done','',2);
Status2('done','',3);
