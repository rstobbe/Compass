%==================================
% 
%==================================

function [MOD,err] = FirSysModelSiemens_General_v1d_Func(MOD,INPUT)

Status2('busy','Regress FIR System Model',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
MFEVO = INPUT.MFEVO;
GWFM = MFEVO.FEVOL.SysTest.IMP.GWFM;
GradField0 = MFEVO.GradField;
Time0 = MFEVO.Time;
GradImp0 = GWFM.Gshapes;
TimeImp0 = GWFM.T;
Number = INPUT.Number;
Dir = INPUT.Dir; 
clear INPUT;

%---------------------------------------------
% Get Regresion Length
%---------------------------------------------
dwell = Time0(2) - Time0(1);
regend = Time0(end);
regressiondelay = 20;

%---------------------------------------------
% Fiddle
%---------------------------------------------
GradField0(isnan(GradField0)) = 0;
GradField = (interp1(Time0+regressiondelay/1000,GradField0.',Time0,'linear',0)).';                          % value at middle of dwell 'step'
Time = (0:dwell:regend);
GradImp = (interp1(TimeImp0(1:end-1)-0.0001,GradImp0.',Time,'previous',0)).';                               % also value at middle of dwell 'step'

%---------------------------------------------
% Min and Max
%---------------------------------------------
MinGrad = find(GWFM.gval >= MOD.mingradinreg,1,'last'); 
MaxGrad = find(GWFM.gval <= MOD.maxgradinreg,1,'first'); 
GradUse = MaxGrad:MinGrad;

%---------------------------------------------
% Get Input
%---------------------------------------------
fh = figure(2346339);
fh.Name = 'Transient Fields (dotted = min/max used in regression)';
fh.NumberTitle = 'off'; 
fh.Position = [400 500 1400 400];
N = (1:length(GWFM.gval));
subplot(1,3,Number); hold on;
plot([0 max(MFEVO.Time)],[0 0],'k-'); 
plot(GWFM.L,GWFM.Gvis(N,:),'k','linewidth',1);
%plot(Time,GradImp(N,:),'k*','linewidth',1);
plot(Time,GradField(N,:),'r');  
xlim([0 3]);
ylim([-GWFM.gstop-1 GWFM.gstop+1]); 
plot(Time,MFEVO.gval(MaxGrad)*ones(size(Time)),'k:');  
plot(Time,MFEVO.gval(MinGrad)*ones(size(Time)),'k:');  
xlabel('(ms)'); 
ylabel('Gradient Evolution (mT/m)'); title([Dir,' Transient Fields']);

MOD.Figure(1).Name = 'Transient Fields For Model';
MOD.Figure(1).Type = 'Graph';
MOD.Figure(1).hFig = fh;
MOD.Figure(1).hAx = gca;

%---------------------------------------------
% Find Filter Coefficients
%---------------------------------------------
m = 1;
for n = GradUse
    SysOb = dsp.RLSFilter(MOD.filtlen,'Method','Householder RLS');
    reset(SysOb);
    tGradImp = GradImp(n,:);
    tGradField = GradField(n,:);
    [y,e] = step(SysOb,tGradImp.',tGradField.');
    filtcoeff0 = SysOb.Coefficients;
    filtcoeffarr(m,:) = filtcoeff0;
    m = m+1;
end
    
%---------------------------------------------
% Test
%---------------------------------------------
filtcoeff = mean(filtcoeffarr,1);
filt = dsp.FIRFilter;
reset(filt);
filt.Numerator = filtcoeff;
Test = step(filt,GradImp(N,:).');
figure(fh);
plot(Time,Test,'b');

%---------------------------------------------
% Test Effective Trajectory Delay
%---------------------------------------------
TestGrad = MaxGrad;
ind = find(GradImp(TestGrad,:) > 6,1,'first');
MidGradStep = (GradImp(TestGrad,ind)+GradImp(TestGrad,ind-1))/2;
tshift = interp1(Test(ind-12:ind+12,TestGrad),Time(ind-12:ind+12),MidGradStep);
plot([Time(ind) tshift],[MidGradStep MidGradStep],'b-*');
efftrajdel = tshift - Time(ind);

%---------------------------------------------
% Output
%---------------------------------------------
fh = figure(2000); hold on;
fh.Name = 'System Model FIR Coefficients';
fh.NumberTitle = 'off'; 
fh.Position = [400 500 1400 400];
subplot(1,3,Number); hold on;
stem(filtcoeff);
xlabel('Sampling Points');
title([Dir,' System Model FIR Coefficients']);

MOD.Figure(2).Name = 'System Model FIR Coefficients';
MOD.Figure(2).Type = 'Graph';
MOD.Figure(2).hFig = fh;
MOD.Figure(2).hAx = gca;

fh = figure(2001); hold on;
fh.Name = 'System Model FIR Coefficients';
fh.NumberTitle = 'off'; 
fh.Position = [400 500 1400 400];
subplot(1,3,Number); hold on;
t = (0:dwell:dwell*(MOD.filtlen-1));
plot(t,filtcoeff);
plot(t,zeros(size(t)),'k');
xlabel('(ms)');
title([Dir,' System Model FIR Coefficients']);

MOD.Figure(3).Name = 'System Model FIR Coefficients';
MOD.Figure(3).Type = 'Graph';
MOD.Figure(3).hFig = fh;
MOD.Figure(3).hAx = gca;

fh = figure(2002); hold on;
fh.Name = 'System Model Frequency Response';
fh.NumberTitle = 'off'; 
fh.Position = [400 500 1400 400];
subplot(1,3,Number); hold on;
[h,w] = freqz(filt);
plot((1/(2*dwell))*w/pi,abs(h));
xlabel('kHz');
title([Dir,' System Model Frequency Response']);

MOD.Figure(4).Name = 'System Model Frequency Response';
MOD.Figure(4).Type = 'Graph';
MOD.Figure(4).hFig = fh;
MOD.Figure(4).hAx = gca;

%---------------------------------------------
% Get Input
%---------------------------------------------
fh = figure(2346340);
fh.Name = 'Transient Fields';
fh.NumberTitle = 'off'; 
fh.Position = [400 500 1400 400];
N = MaxGrad;
subplot(1,3,Number); hold on;
plot([0 max(MFEVO.Time)],[0 0],'k-'); 
plot(GWFM.L,GWFM.Gvis(N,:),'k','linewidth',1);
plot(Time,GradField0(N,:),'r');  
plot(Time-regressiondelay/1000,Test(:,N),'b');
xlim([0.25 0.6]);
ylim([0 GWFM.gval(N)+1]); 
xlabel('(ms)'); 
ylabel('Gradient Evolution (mT/m)'); title([Dir,' Transient Field']);

MOD.Figure(5).Name = 'Transient Fields';
MOD.Figure(5).Type = 'Graph';
MOD.Figure(5).hFig = fh;
MOD.Figure(5).hAx = gca;

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'',[],'Output'};
Panel(2,:) = {'Field Anlysis File',MFEVO.name,'Output'};
Panel(3,:) = {'Filter Length',MOD.filtlen,'Output'};
Panel(4,:) = {'Max Gradient in Regression (mT/m)',MFEVO.gval(MaxGrad),'Output'};
Panel(5,:) = {'Regression Delay (ms)',regressiondelay,'Output'};
Panel(6,:) = {'Delay Gradient when Implementing (ms)',MOD.delaygradient,'Output'};
Panel(7,:) = {'Resultant Effective Trajectory Delay (ms)',efftrajdel,'Output'};
MOD.PanelOutput = cell2struct(Panel,{'label','value','type'},2);
MOD.ExpDisp = PanelStruct2Text(MOD.PanelOutput);

%---------------------------------------------
% Output
%---------------------------------------------
MOD.filtcoeff = filtcoeff;
MOD.regressiondelay = regressiondelay; 
MOD.efftrajdel = efftrajdel;
MOD.dwell = dwell;

Status2('done','',2);
Status2('done','',3);

