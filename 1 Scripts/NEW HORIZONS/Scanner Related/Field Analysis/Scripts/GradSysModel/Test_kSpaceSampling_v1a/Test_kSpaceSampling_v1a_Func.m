%==================================================
% 
%==================================================

function [TSTMOD,err] = Test_kSpaceSampling_v1a_Func(TSTMOD,INPUT)

Status('busy','Test k-Space Sampling');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
MFEVO = INPUT.MFEVO;
IMP = MFEVO.FEVOL.SysTest.IMP;
GWFM = IMP.GWFM;
GradField0 = MFEVO.GradField;
Time0 = MFEVO.Time;
clear INPUT;

%---------------------------------------------
% Get kSpace Value
%---------------------------------------------
Status2('busy','Find kSpace Values',2);
Time = Time0 - Time0(1);                        % Time0 is the time at the middle of a gradient 'step' - Time indicates beginning of 'step'
GradField0(isnan(GradField0)) = 0;
GradField = repmat(GradField0,[1 1 3]);         % needs to be 3D
gamma = 42.577;
[Kmat0,Kend] = ReSampleKSpace_v7a(GradField,Time,Time,gamma);
Kmat0 = squeeze(Kmat0(:,:,1));

%---------------------------------------------
% Plot
%---------------------------------------------
fh = figure(1000); hold on; 
fh.Position = [400 150 1000 800];
plot(Time,squeeze(Kmat0(TSTMOD.trajnum,:)),'k');  
plot(GWFM.samp+GWFM.pregdur,GWFM.Kmat(TSTMOD.trajnum,:),'r*');  
xlabel('(ms)'); ylabel('kSpace (1/m)'); title('Trajectory Evolution');

%---------------------------------------------
% Return
%---------------------------------------------
TSTMOD.ExpDisp = '';


Status('done','');
Status2('done','',2);
Status2('done','',3);