%==================================
% 
%==================================

function [MOD,err] = FirSysModelRegress_v1a_Func(MOD,INPUT)

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
clear INPUT;

%---------------------------------------------
% Get Regresion Length
%---------------------------------------------
dwell = Time0(2) - Time0(1);
if strcmp(MOD.subrgrslen,'full')
    regend = Time0(end);
else
    regend = str2double(MOD.subrgrslen);
end

%---------------------------------------------
% Fiddle
%---------------------------------------------
GradField0(isnan(GradField0)) = 0;
Time = (0:dwell:regend);
GradField = (interp1(Time0+MOD.graddel/1000,GradField0.',Time,'linear',0)).';
GradImp = (interp1(TimeImp0(1:end-1)-0.0001,GradImp0.',Time,'previous',0)).';

%---------------------------------------------
% Get Input
%---------------------------------------------
N = (5:5:30);
fh = figure(1000); hold on; 
fh.Position = [400 150 1000 800];
plot([0 max(MFEVO.Time)],[0 0],'k:'); 
plot(GWFM.L,GWFM.Gvis(N,:),'k','linewidth',1);
plot(Time,GradImp(N,:),'k*','linewidth',1);
%plot(Time0,GradField0,'b');    
plot(Time,GradField(N,:),'r');  
%ylim([-max(abs(GWFM.Gvis(N,:))) max(abs(GWFM.Gvis(N,:)))]);
xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); title('Transient Field (Gradient)');

%---------------------------------------------
% Find Filter Coefficients
%---------------------------------------------
m = 1;
for n = 20:30
    SysOb = dsp.RLSFilter(250,'Method','Householder RLS');
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
figure(1000);
plot(Time,Test,'m');

figure(2000); hold on;
stem(filtcoeff);

