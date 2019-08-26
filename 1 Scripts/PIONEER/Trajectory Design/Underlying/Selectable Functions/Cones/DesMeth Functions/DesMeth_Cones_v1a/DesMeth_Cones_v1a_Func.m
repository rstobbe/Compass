%==================================================
% 
%==================================================

function [DESMETH,err] = DesMeth_Cones_v1a_Func(DESMETH,INPUT)

Status('busy','Create Cones Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
clear INPUT

%---------------------------------------------
% Describe Trajectory
%---------------------------------------------
DESMETH.type = 'Cones';

%---------------------------------------------
% Build Cones
%---------------------------------------------
DesGradPeriod = 0.002;          % in ms
Precision = 0.001;              % to get readout length right...
GradRewindInTro = 0;            % include rewinder in length
OverSample = 1;                 % oversample
SlewRate = 120;                 % Slew rate (in mT/m/ms)
GradMax = 80;                   % Max Gradient Amplitude (in mT/m)
DCF = 1.0;                      % Density Compensation Factor

Len = PROJdgn.tro/DesGradPeriod;
Ncones = ceil((pi/2)*(PROJdgn.fov/PROJdgn.vox));
ThetaStep = pi/Ncones;
ThetaArr = (0+ThetaStep/2:ThetaStep:pi/2);
G = zeros(length(ThetaArr),Len,3);
GradSampTim0 = (DesGradPeriod:DesGradPeriod:PROJdgn.tro);

for n = 1:round(0.75*length(ThetaArr))
%for n = 1:round(0.80*length(ThetaArr))
    [GradTemp,~,NumIntlve(n)] = findcone(PROJdgn.vox,PROJdgn.fov/10,Len,ThetaArr(n),...
                             Precision,DesGradPeriod/1000,GradRewindInTro,OverSample,SlewRate*100,GradMax/10,DCF);
    GradTemp = GradTemp*10;
    figure(1234); clf; hold on;
    GradSampTim = GradSampTim0(1:length(GradTemp));
    plot(GradSampTim,GradTemp(:,1),'b'); plot(GradSampTim,GradTemp(:,2),'g'); plot(GradSampTim,GradTemp(:,3),'r');
    xlim([0 PROJdgn.tro]);
    if n == 1
        setylim = [-10*ceil(max(GradTemp(:))/10) 10*ceil(max(GradTemp(:))/10)];
    end
    ylim(setylim);
    xlabel('Readout Duration (ms)');
    ylabel('Gradient (mT/m)');    
    G(n,1:length(GradTemp),:) = GradTemp;
end
NumIntlve(n+1:length(ThetaArr)) = NumIntlve(n);
TotalTrajEst = sum(ceil(NumIntlve))*2;

%------------------------------------------
% Calculate undersampling
%------------------------------------------
PROJdgn.projosamp = PROJdgn.nproj/TotalTrajEst;
    
%--------------------------------------------
% Name
%--------------------------------------------
sfov = num2str(PROJdgn.fov,'%03.0f');
svox = num2str(10*(PROJdgn.vox^3),'%04.0f');
stro = num2str(10*PROJdgn.tro,'%03.0f');
snproj = num2str(PROJdgn.nproj,'%4.0f');
DESMETH.name = ['DES_F',sfov,'_V',svox,'_T',stro,'_N',snproj,'_Cones'];    
    
%------------------------------------------
% Return
%------------------------------------------
DESMETH.PROJdgn = PROJdgn;
DESMETH.PanelOutput = [];
DESMETH.Panel2Imp = [];

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'Method',DESMETH.method,'Output'};
Panel(2,:) = {'FoV Design (mm)',PROJdgn.fov,'Output'};
Panel(3,:) = {'VoxWidNom (mm)',PROJdgn.vox,'Output'};
Panel(4,:) = {'VoxWidCeq (mm)',PROJdgn.vox*1.24,'Output'};
Panel(5,:) = {'VoxVol (mm3)',((PROJdgn.vox*1.24)^3),'Output'};
Panel(6,:) = {'Tro (ms)',PROJdgn.tro,'Output'};
Panel(7,:) = {'Ntraj',PROJdgn.nproj,'Output'};
Panel(8,:) = {'OverSampGuess',PROJdgn.projosamp,'Output'};

DESMETH.PanelOutput = cell2struct(Panel,{'label','value','type'},2);
DESMETH.Panel2Imp = Panel;

Status('done','');
Status2('done','',2);
Status2('done','',3);


