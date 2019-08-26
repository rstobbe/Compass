%==================================================
% 
%==================================================

function [TSTMOD,err] = Test_GradSysResponse_v1a_Func(TSTMOD,INPUT)

Status('busy','Test Gradient System Response Model');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
MFEVO = INPUT.MFEVO;
MOD = INPUT.MOD;
IMP = MFEVO.FEVOL.SysTest.IMP;
GWFM = IMP.GWFM;
GradField0 = MFEVO.GradField;
Time0 = MFEVO.Time;
GradImp0 = GWFM.Gshapes;
TimeImp0 = GWFM.T;
clear INPUT;

%---------------------------------------------
% Fiddle
%---------------------------------------------
GradField0(isnan(GradField0)) = 0;
Time = (0:MOD.dwell:Time0(end));
GradField = (interp1(Time0+MOD.regressiondelay/1000,GradField0.',Time,'linear',0)).';
GradImp = (interp1(TimeImp0(1:end-1)-0.0001,GradImp0.',Time,'previous',0)).';

%---------------------------------------------
% Get Input
%---------------------------------------------
fh = figure(1000); hold on; 
fh.Position = [400 150 1000 800];
plot([0 max(MFEVO.Time)],[0 0],'k:'); 
plot(GWFM.L,GWFM.Gvis(TSTMOD.trajnum,:),'k','linewidth',1);
%plot(Time,GradImp(TSTMOD.trajnum,:),'k*','linewidth',1);        % to make sure interpolation right
plot(Time,GradField(TSTMOD.trajnum,:),'r');  
xlabel('(ms)'); ylabel('Gradient Evolution (mT/m)'); title('Transient Field (Gradient)');

%---------------------------------------------
% Test
%---------------------------------------------
filt = dsp.FIRFilter;
reset(filt);
if strcmp(MFEVO.graddir,'X')
    filt.Numerator = MOD.filtcoeff(:,1).';
elseif strcmp(MFEVO.graddir,'Y')
    filt.Numerator = MOD.filtcoeff(:,2).';
elseif strcmp(MFEVO.graddir,'Z')
    filt.Numerator = MOD.filtcoeff(:,3).';
end
GradOut = step(filt,GradImp(TSTMOD.trajnum,:).');
figure(1000);
plot(Time,GradOut,'m');

%---------------------------------------------
% Return
%---------------------------------------------
TSTMOD.ExpDisp = '';


Status('done','');
Status2('done','',2);
Status2('done','',3);