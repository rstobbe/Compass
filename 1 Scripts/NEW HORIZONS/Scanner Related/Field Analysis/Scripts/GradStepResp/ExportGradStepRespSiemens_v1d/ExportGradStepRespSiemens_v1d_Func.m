%==================================================
% 
%==================================================

function [SR,err] = ExportGradStepRespSiemens_v1d_Func(SR,INPUT)

Status('busy','Export Step Response');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
TGFX = INPUT.TGFX;
TGFY = INPUT.TGFY;
TGFZ = INPUT.TGFZ;
GWFM = TGFZ.FEVOL.SysTest.IMP.GWFM;
clear INPUT

%-----------------------------------------------------
% Test 
%-----------------------------------------------------
if SR.Gmax > GWFM.gstop
    err.flag = 1;
    err.msg = ['Max Grad < ', num2str(GWFM.gstop)];
    return
end

%-----------------------------------------------------
% Test to Make Sure 'TGFs' Same...
%-----------------------------------------------------

%-----------------------------------------------------
% Get Variables
%-----------------------------------------------------
delaygrad = SR.graddel/1000;
Tstep = SR.Tstep;
Tmax = SR.Tmax;

%-----------------------------------------------------
% Get Gradient Info
%-----------------------------------------------------
L0 = GWFM.L;
Gvis0 = GWFM.Gvis;
initfall = GWFM.pregdur + GWFM.gatmaxdur*2 + GWFM.intergdur;
initrise = GWFM.pregdur;
gval = GWFM.gval;
ngrads = length(gval);
gsl = GWFM.gsl;

%-----------------------------------------------------
% Get Transient Field Info
%-----------------------------------------------------
Time0 = TGFX.Time;
GradFieldX0 = TGFX.GradField;
GradFieldY0 = TGFY.GradField;
GradFieldZ0 = TGFZ.GradField;

%-----------------------------------------------------
% Adjust Time0  
%   - adjust for gradient delay
%-----------------------------------------------------
Time0 = Time0 + delaygrad;

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
fh0 = figure(1000);
fh0.Name = 'Full Step Response to Input Comparison';
fh0.NumberTitle = 'off'; 
fh0.Position = [400 150 1000 800];
subplot(2,2,1); hold on; 
plot([0 max(Time0)],[0 0],'k:'); 
plot(Time0,GradFieldX0,'r');
plot(L0,Gvis0,'k');
xlim([initrise-0.1 initfall + 0.2]);
ylim([-max(gval)-1 max(gval)+1]);
xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); title('X');
subplot(2,2,2); hold on; 
plot([0 max(Time0)],[0 0],'k:'); 
plot(Time0,GradFieldY0,'b');
plot(L0,Gvis0,'k');
xlim([initrise-0.1 initfall + 0.2]);
ylim([-max(gval)-1 max(gval)+1]);
xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); title('Y');
subplot(2,2,3); hold on; 
plot([0 max(Time0)],[0 0],'k:'); 
plot(Time0,GradFieldZ0,'g');
plot(L0,Gvis0,'k');
xlim([initrise-0.1 initfall + 0.2]);
ylim([-max(gval)-1 max(gval)+1]);
xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); title('Z');

%-----------------------------------------------------
% Find Final Value
%-----------------------------------------------------
ind1 = find(Time0 < initfall - 0.05,1,'last');
meanstart = Time0(ind1);
ind2 = find(Time0 < initfall - 0.02,1,'last');
meanstop = Time0(ind2);
subplot(2,2,1);
plot([meanstart meanstart],[-max(gval)-1 max(gval)-1],'c');
plot([meanstop meanstop],[-max(gval)-1 max(gval)-1],'c');
subplot(2,2,2);
plot([meanstart meanstart],[-max(gval)-1 max(gval)-1],'c');
plot([meanstop meanstop],[-max(gval)-1 max(gval)-1],'c');
subplot(2,2,3);
plot([meanstart meanstart],[-max(gval)-1 max(gval)-1],'c');
plot([meanstop meanstop],[-max(gval)-1 max(gval)-1],'c');
GradFieldXstart = mean(GradFieldX0(:,ind1:ind2),2);
GradFieldYstart = mean(GradFieldY0(:,ind1:ind2),2);
GradFieldZstart = mean(GradFieldZ0(:,ind1:ind2),2);

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
fh1 = figure(1001);
fh1.Name = 'Step Response Details';
fh1.NumberTitle = 'off'; 
fh1.Position = [400 150 1000 800];
subplot(2,2,1); hold on;
plot(gval,GradFieldXstart' + gval,'r');
plot(gval,GradFieldYstart' + gval,'b');
plot(gval,GradFieldZstart' + gval,'g');
title('Gradient Magnitude Error'); 
xlabel('Gradient Magnitude (mT/m)'); ylabel('(mT/m)');

%-----------------------------------------------------
% Interpolate and Segment
%-----------------------------------------------------
GradField0 = cat(3,GradFieldX0,GradFieldY0,GradFieldZ0);
Time = (0:Tstep:Tmax);
GradField0 = permute(GradField0,[2 1 3]);
GradField = interp1(Time0,GradField0,initrise+Time);
GradField = permute(GradField,[2 1 3]);
GradFieldFall = interp1(Time0,GradField0,initfall+Time);
GradFieldFall = permute(GradFieldFall,[2 1 3]);

%-----------------------------------------------------
% Calculate Slopes
%-----------------------------------------------------
for m = 1:3
    for n = 1:ngrads
        sub = find(GradField(n,:,m) == max(GradField(n,:,m)));
        bT95(n,m) = interp1(GradField(n,(1:sub),m),Time(1:sub),gval(n)*0.95);
        bT90(n,m) = interp1(GradField(n,(1:sub),m),Time(1:sub),gval(n)*0.90);
        bT85(n,m) = interp1(GradField(n,(1:sub),m),Time(1:sub),gval(n)*0.85);
        bT80(n,m) = interp1(GradField(n,(1:sub),m),Time(1:sub),gval(n)*0.80);
        tT05(n,m) = interp1(GradField(n,(1:sub),m),Time(1:sub),gval(n)*0.05);
        tT10(n,m) = interp1(GradField(n,(1:sub),m),Time(1:sub),gval(n)*0.10);
        tT15(n,m) = interp1(GradField(n,(1:sub),m),Time(1:sub),gval(n)*0.15);
        tT20(n,m) = interp1(GradField(n,(1:sub),m),Time(1:sub),gval(n)*0.20);
    end
    slope90(:,m) = -(0.9*gval.')./(tT05(:,m) - bT95(:,m));
    slope80(:,m) = -(0.8*gval.')./(tT10(:,m) - bT90(:,m));  
    slope70(:,m) = -(0.7*gval.')./(tT15(:,m) - bT85(:,m));  
    slope60(:,m) = -(0.6*gval.')./(tT20(:,m) - bT80(:,m));  
end
figure(fh1); 
subplot(2,2,2); hold on;
plot(gval,slope90(:,1),'r'); plot(gval,slope80(:,1),'r--'); plot(gval,slope70(:,1),'r-.'); plot(gval,slope60(:,1),'r:');   
plot(gval,slope90(:,2),'b'); plot(gval,slope80(:,2),'b--'); plot(gval,slope70(:,2),'b-.'); plot(gval,slope60(:,2),'b:');  
plot(gval,slope90(:,3),'g'); plot(gval,slope80(:,3),'g--'); plot(gval,slope70(:,3),'g-.'); plot(gval,slope60(:,3),'g:');  
ind = find(gval >= SR.Gmax,1,'first'); 
SlewRate = mean(slope80(ind,:));
title('Gradient Slew Rate');
ylabel('(mT/m/ms)'); xlabel('Gradient Magnitude (mT/m)');
if isnan(SlewRate)
    err.flag = 1;
    err.msg = 'Gradient Signs Wrong';
    return
end

%-----------------------------------------------------
% Isolate
%-----------------------------------------------------
GvalUse = gval(gval <= SR.Gmax);
GradField = GradField(gval <= SR.Gmax,:,:);
GradFieldFall = GradFieldFall(gval <= SR.Gmax,:,:);

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
fh2 = figure(1002);
fh2.Name = 'Rise and Fall Step Response';
fh2.NumberTitle = 'off'; 
fh2.Position = [400 150 1000 800];
subplot(2,2,1); hold on; 
plot([0 max(Time)],[0 0],'k:'); 
plot(Time,GradField(:,:,1),'r');
plot(Time,GradFieldFall(:,:,1),'r:');
title('X');
ylabel('(mT/m)'); xlabel('(ms)');
subplot(2,2,2); hold on; 
plot([0 max(Time)],[0 0],'k:'); 
plot(Time,GradField(:,:,2),'b');
plot(Time,GradFieldFall(:,:,2),'b:');
title('Y');
ylabel('(mT/m)'); xlabel('(ms)');
subplot(2,2,3); hold on; 
plot([0 max(Time)],[0 0],'k:'); 
plot(Time,GradField(:,:,3),'g');
plot(Time,GradFieldFall(:,:,3),'g:');
title('Z');
ylabel('(mT/m)'); xlabel('(ms)');

%-----------------------------------------------------
% Find Remaining at End
%-----------------------------------------------------
%RemEndX = GvalUse-GradField(:,length(Time),1)';                % not used
%RemEndY = GvalUse-GradField(:,length(Time),2)';
%RemEndZ = GvalUse-GradField(:,length(Time),3)';
RemEndXFall = GradFieldFall(:,length(Time),1)';
RemEndYFall = GradFieldFall(:,length(Time),2)';
RemEndZFall = GradFieldFall(:,length(Time),3)';

%-----------------------------------------------------
% Plot Remaining at End
%-----------------------------------------------------
figure(fh1);
subplot(2,2,3); hold on;
%plot(GvalUse,RemEndX,'r:');            % not used
%plot(GvalUse,RemEndY,'b:');
%plot(GvalUse,RemEndZ,'g:');
%MaxRemEndX = max(RemEndX);
%MaxRemEndY = max(RemEndY);
%MaxRemEndZ = max(RemEndZ);
plot(GvalUse,RemEndXFall,'r');
plot(GvalUse,RemEndYFall,'b');
plot(GvalUse,RemEndZFall,'g');
MaxAbsRemEndXFall = max(abs(RemEndXFall));
MaxAbsRemEndYFall = max(abs(RemEndYFall));
MaxAbsRemEndZFall = max(abs(RemEndZFall));
title('Remaining at End'); 
xlabel('Gradient Magnitude (mT/m)'); ylabel('(mT/m)');

%-----------------------------------------------------
% Normalize
%-----------------------------------------------------
for m = 1:3
    for n = 1:ngrads
        GradField(n,:,m) = GradField(n,:,m)/GvalUse(n);
        GradFieldFall(n,:,m) = (GvalUse(n) + GradFieldFall(n,:,m))/GvalUse(n);
    end
end
GradField(:,length(GradField(1,:,1)),:) = 1;
GradFieldFall(:,length(GradFieldFall(1,:,1)),:) = 1;

%-----------------------------------------------------
% Join (Rise to Start - Fall to End)
%-----------------------------------------------------
ind = find(Time > SR.R2Fswitch,1,'first');
GradField = cat(2,GradField(:,1:ind,:),GradFieldFall(:,ind+1:length(Time),:));

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
fh3 = figure(1003);
fh3.Name = 'Saved Step Response (Rise to start - Fall to end)';
fh3.NumberTitle = 'off'; 
fh3.Position = [400 150 1000 800];
subplot(2,2,1); hold on;
plot([0 max(Time)],[0 0],'k:'); 
%plot(Time,GradFieldFall(1,:,1),'k');
%plot(Time,GradFieldFall(round(ngrads/2),:,1),'k');
%plot(Time,GradFieldFall(ngrads,:,1),'k');
plot([SR.R2Fswitch SR.R2Fswitch],[0.7 1.1],'k:');
plot(Time,GradField(1,:,1),'r');
plot(Time,GradField(round(ngrads/2),:,1),'r');
plot(Time,GradField(ngrads,:,1),'r');
title('X'); 
xlabel('(mT/m)'); ylabel('(ms)');
subplot(2,2,2); hold on;
plot([0 max(Time)],[0 0],'k:'); 
%plot(Time,GradFieldFall(1,:,2),'k');
%plot(Time,GradFieldFall(round(ngrads/2),:,2),'k');
%plot(Time,GradFieldFall(ngrads,:,2),'k');
plot([SR.R2Fswitch SR.R2Fswitch],[0.7 1.1],'k:');
plot(Time,GradField(1,:,2),'b');
plot(Time,GradField(round(ngrads/2),:,2),'b');
plot(Time,GradField(ngrads,:,2),'b');
title('Y'); 
xlabel('(mT/m)'); ylabel('(ms)');
subplot(2,2,3); hold on;
plot([0 max(Time)],[0 0],'k:'); 
%plot(Time,GradFieldFall(1,:,3),'k');
%plot(Time,GradFieldFall(round(ngrads/2),:,3),'k');
%plot(Time,GradFieldFall(ngrads,:,3),'k');
plot([SR.R2Fswitch SR.R2Fswitch],[0.7 1.1],'k:');
plot(Time,GradField(1,:,3),'g');
plot(Time,GradField(round(ngrads/2),:,3),'g');
plot(Time,GradField(ngrads,:,3),'g');
title('Z'); 
xlabel('(mT/m)'); ylabel('(ms)');

%-----------------------------------------------------
% Return
%-----------------------------------------------------
SR.t = Time;
SR.step = SR.Tstep;
SR.T = SR.Tmax;
SR.N = length(Time);
SR.Ginc = GWFM.gstep;
SR.Gmin = GWFM.gstart;
SR.GSR = flip(GradField,1);
SR.MeasSlewRate = SlewRate;
SR.PrescribedSlewRate = GWFM.gsl;

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'RemEndX (mT/m)',MaxAbsRemEndXFall,'Output'};
Panel(2,:) = {'RemEndY (mT/m)',MaxAbsRemEndYFall,'Output'};
Panel(3,:) = {'RemEndZ (mT/m)',MaxAbsRemEndZFall,'Output'};
Panel(4,:) = {'MeanSlewAtGmax',SR.MeasSlewRate,'Output'};
Panel(5,:) = {'PrescribedSlew',SR.PrescribedSlewRate,'Output'};
Panel(6,:) = {'graddel (us)',SR.graddel,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
SR.PanelOutput = PanelOutput;
SR.ExpDisp = PanelStruct2Text(SR.PanelOutput);

Status('done','');
Status2('done','',2);
Status2('done','',3);
