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
    regend = Time0(end)-dwell;
else
    regend = str2double(MOD.subrgrslen);
end

%---------------------------------------------
% Fiddle
%---------------------------------------------
GradField0(isnan(GradField0)) = 0;
Time = (0:dwell:regend);
GradField1 = (interp1(Time0+MOD.graddel/1000,GradField0.',Time,'linear',0)).';
GradImp1 = (interp1(TimeImp0(1:end-1)-0.0001,GradImp0.',Time,'previous',0)).';

GradField = reshape(GradField1.',1,[]);
GradImp = reshape(GradImp1.',1,[]);

%---------------------------------------------
% Get Input
%---------------------------------------------
fh = figure(1000); hold on; 
fh.Position = [400 150 1000 800];
plot([0 max(MFEVO.Time)],[0 0],'k:'); 
plot(GradImp,'k');
plot(GradField,'r');  
xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); title('Transient Field (Gradient)');

%---------------------------------------------
% Find Filter Coefficients
%---------------------------------------------
SysOb = dsp.RLSFilter(128,'Method','Householder RLS');
reset(SysOb);
[y,e] = step(SysOb,GradImp.',GradField.');
plot(y,'b');
filtcoeff = SysOb.Coefficients;
    
%---------------------------------------------
% Test
%---------------------------------------------
figure(2001); hold on;
stem(filtcoeff);

filt = dsp.FIRFilter;
reset(filt);
filt.Numerator = filtcoeff;
Test = step(filt,GradImp);
figure(1000);
plot(Test,'m');


