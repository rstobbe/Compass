%=====================================================
% 
%=====================================================

function [IMETH,err] = ImpMeth_LRideal_v3a_Func(IMETH,INPUT)

Status2('busy','Implement Ideal LR',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test if Implementation Valid
%---------------------------------------------
if not(strcmp(INPUT.DES.type,'LR3D') || strcmp(INPUT.DES.type,'YB'))
    err.flag = 1;
    err.msg = 'ImpMeth_LRstandard is not valid for the trajectory design';
    return
end

%---------------------------------------------
% Get Input
%---------------------------------------------
DES = INPUT.DES;
PROJdgn = DES.PROJdgn;
SPIN = INPUT.DES.SPIN;
SYS = INPUT.SYS;
PROJimp = INPUT.PROJimp;
TST = INPUT.TST;
DESOL = IMETH.DESOL;
PSMP = IMETH.PSMP;
TSMP = IMETH.TSMP;
clear INPUT

%---------------------------------------------
% Test for Design Routine
%---------------------------------------------
if not(exist(DES.genprojfunc,'file'))
    err.flag = 1;
    err.msg = 'Folder of Common LR routines must be added to path';
    return
end
genprojfunc = str2func(DES.genprojfunc);

%---------------------------------------------
% Update Visualization from Test Function
%---------------------------------------------
KSMP.Vis = TST.KSMP.Vis;
DESOL.Vis = TST.DESOL.Vis;


%===============================================================================
% Define Projection Sampling
%===============================================================================
func = str2func([IMETH.psmpfunc,'_Func']);
INPUT.PROJdgn = DES.PROJdgn;
INPUT.SPIN = DES.SPIN;
INPUT.testing = 'No';
if isfield(TST,'testprojsubset')
    if strcmp(TST.testprojsubset,'Yes')
        INPUT.testing = 'Yes';
    end
end      
[PSMP,err] = func(PSMP,INPUT);
if err.flag
    return
end
clear INPUT
PROJimp.projosamp = PSMP.projosamp;
PROJimp.nproj = PSMP.nproj;
IMETH.PSMP = PSMP;
IMETH.PROJimp = PROJimp;

    
%===============================================================================
% Test / Tweak
%===============================================================================

%------------------------------------------
% Get LR spinning functions
%------------------------------------------
INPUT.PROJdgn = PROJdgn;
func = str2func([DES.spinfunc,'_Func']);           
[SPIN,err] = func(SPIN,INPUT);
if err.flag
    return
end
clear INPUT;

%------------------------------------------
% Get radial evolution function for DE solution timing
%------------------------------------------
INPUT.PROJdgn = PROJdgn;
INPUT.TST = TST;
INPUT.TST.desoltype = 'FinalSolution';
INPUT.TST.relprojlenmeas = 'No';
func = str2func([IMETH.desoltimfunc,'_Func']);           
[DESOL,err] = func(DESOL,INPUT);
if err.flag
    return
end
clear INPUT;

%----------------------------------------------------
% Test Solution Fineness
%----------------------------------------------------    
INPUT.PROJdgn = PROJdgn;
INPUT.SPIN = SPIN;
INPUT.DESOL = DESOL;
if strcmp(TST.traj,'All')
    INPUT.PSMP.phi = PSMP.phi(1);
    INPUT.PSMP.theta = PSMP.theta(1);
else
    INPUT.PSMP.phi = PSMP.phi(TST.traj);
    INPUT.PSMP.theta = PSMP.theta(TST.traj);
end
INPUT.TST = TST;
[OUTPUT,err] = genprojfunc(INPUT);
if err.flag
    return
end
KSA = OUTPUT.KSA;
T = OUTPUT.T;
clear INPUT;
clear OUTPUT;

%---------------------------------------------
% Test
%---------------------------------------------
Rad = sqrt(KSA(:,:,1).^2 + KSA(:,:,2).^2 + KSA(:,:,3).^2);
Rad = mean(Rad,1);
testtro = interp1(Rad,T,1,'spline');         % ensure proper timing  
if round(testtro*1e6) ~= round(PROJdgn.tro*1e6)
    error
end    

%---------------------------------------------
% Test
%---------------------------------------------
m = 2:length(KSA(1,:,1));
kStep = [KSA(:,1,:) KSA(:,m,:) - KSA(:,m-1,:)];
MagkStep = sqrt(kStep(:,:,1).^2 + kStep(:,:,2).^2 + kStep(:,:,3).^2);
MagkStep = mean(MagkStep,1);
Rad = sqrt(KSA(:,:,1).^2 + KSA(:,:,2).^2 + KSA(:,:,3).^2);
Rad = mean(Rad,1);
if Rad(end) < 1                                 % make sure not solved to less than 1
    RadEnd = Rad(end)
    error
end    

if strcmp(TST.TVis,'Yes')
    fh = figure(500); 
    %clf;
    fh.Name = 'Solution Fineness Testing for Waveform Generation';
    fh.NumberTitle = 'off';
    fh.Position = [200 150 1400 800];
    subplot(2,3,1); hold on; axis equal; grid on; box off;
    plot3(PROJdgn.rad*KSA(1,:,1),PROJdgn.rad*KSA(1,:,2),PROJdgn.rad*KSA(1,:,3),'k-');
    lim = PROJdgn.rad;
    xlim([-lim,lim]); ylim([-lim,lim]); zlim([-lim,lim]);
    xlabel('kStep_x'); ylabel('kStep_y'); zlabel('kStep_z'); title('Full Trajectory');

    subplot(2,3,2); hold on; axis equal; grid on; box off;
    ind = find(Rad >= 2*PROJdgn.p,1);    
    plot3(PROJdgn.rad*KSA(1,1:ind,1),PROJdgn.rad*KSA(1,1:ind,2),PROJdgn.rad*KSA(1,1:ind,3),'k-');
    ploc = interp1(Rad,PROJdgn.rad*squeeze(KSA(1,:,:)),PROJdgn.p,'spline');
    plot3(ploc(1),ploc(2),ploc(3),'rx');
    lim = ceil(PROJdgn.rad*2*PROJdgn.p);
    xlim([-lim,lim]); ylim([-lim,lim]); zlim([-lim,lim]);
    xlabel('kStep_x'); ylabel('kStep_y'); zlabel('kStep_z'); title('Initial Portion');
    set(gca,'cameraposition',[-31 -39 12.5]); 

    subplot(2,3,3); hold on; axis equal; grid on; box off;
    plot3(PROJdgn.rad*KSA(1,:,1),PROJdgn.rad*KSA(1,:,2),PROJdgn.rad*KSA(1,:,3),'k-');
    lim = 0.5;
    xlim([-lim,lim]); ylim([-lim,lim]);
    xlabel('kStep_x'); ylabel('kStep_y'); zlabel('kStep_z');
    set(gca,'cameraposition',[0 0 5000]);
    set(gca,'CameraTargetMode','manual');
    set(gca,'CameraTarget',[0 0 0]);
    set(gca,'xtick',(-0.5:0.25:0.5)); set(gca,'ytick',(-0.5:0.25:0.5)); title('Solution Quantization Deflection @ Centre');

    subplot(2,3,4); hold on;
    plot(Rad,PROJdgn.rad*MagkStep,'k');
    plot([PROJdgn.p PROJdgn.p],PROJdgn.rad*[0 1.1],':');
    plot([0 1],[0.1 0.1],':');
    plot([0 1],[1 1],':');
    ylim([0 1.1]);
    xlabel('Relative Radius'); ylabel('kStep'); xlim([0 1]); title('Solution Sampling Fineness');

    button = questdlg('Continue? (Test Solution Fineness for Waveform Generation)');
    if strcmp(button,'No');
        err.flag = 4;
        err.msg = '';
        return
    end    
end 

%---------------------------------------------
% Return
%--------------------------------------------- 
IMETH.impPROJdgn = PROJdgn;
IMETH.PROJimp = PROJimp;
IMETH.ConstEvolT = T;
IMETH.ConstEvolRad = Rad;
IMETH.SPIN = SPIN;   


%===============================================================================
% Generate Design
%===============================================================================

%------------------------------------------
% Get radial evolution function for DE solution timing
%------------------------------------------
INPUT.PROJdgn = PROJdgn;
INPUT.TST = TST;
INPUT.TST.desoltype = 'FinalSolution';
func = str2func([IMETH.desoltimfunc,'_Func']);           
[DESOL,err] = func(DESOL,INPUT);                            
if err.flag
    return
end
clear INPUT;

%----------------------------------------------------
% Generate
%----------------------------------------------------    
INPUT.PROJdgn = PROJdgn;
INPUT.SPIN = IMETH.SPIN;
INPUT.DESOL = DESOL;
INPUT.PSMP = PSMP;
if not(strcmp(TST.traj,'All'))
    INPUT.PSMP.phi = PSMP.phi(TST.traj);
    INPUT.PSMP.theta = PSMP.theta(TST.traj);
end
INPUT.TST = TST;
[OUTPUT,err] = genprojfunc(INPUT);
if err.flag
    return
end
KSA = OUTPUT.KSA;
clear INPUT;
clear OUTPUT;    

%---------------------------------------------
% Test
%---------------------------------------------
Rad = sqrt(KSA(:,:,1).^2 + KSA(:,:,2).^2 + KSA(:,:,3).^2);
Rad = mean(Rad,1);
if Rad(end) < 1                                 % make sure not solved to less than 1
    RadEnd = Rad(end)
    error
end      

%------------------------------------------
% Solve T at Evolution Constraint
%------------------------------------------
T = interp1(IMETH.ConstEvolRad,IMETH.ConstEvolT,Rad,'spline');
IMETH.T = T;

testtro = interp1(Rad,T,1,'spline'); 
if round(testtro*1e6) ~= round(PROJdgn.tro*1e6)
    error
end

%------------------------------------------
% Return
%------------------------------------------
IMETH.KSA = KSA;


%===============================================================================
% Build
%===============================================================================
% nothing...


%===============================================================================
% TrajSamp
%===============================================================================
func = str2func([IMETH.tsmpfunc,'_Func']);
INPUT.PROJdgn = PROJdgn;
INPUT.PROJimp = PROJimp;
INPUT.GWFM = IMETH;
INPUT.SYS = SYS;
[TSMP,err] = func(TSMP,INPUT);
if err.flag
    ErrDisp(err);
    return
end
clear INPUT
PROJimp.dwell = TSMP.dwell;
PROJimp.tro = TSMP.tro;
PROJimp.trajosamp = TSMP.trajosamp;
IMETH.TSMP = TSMP;


%===============================================================================
% Recon
%===============================================================================

%---------------------------------------------
% Sample
%---------------------------------------------
SampRecon = (TSMP.sampstart:TSMP.dwell:TSMP.tro);    
sz = size(IMETH.KSA);
for n = 1:sz(1)
    KmatRecon(n,:,1) = interp1(IMETH.T,IMETH.KSA(n,:,1)*PROJdgn.rad*PROJdgn.kstep,SampRecon);
    KmatRecon(n,:,2) = interp1(IMETH.T,IMETH.KSA(n,:,2)*PROJdgn.rad*PROJdgn.kstep,SampRecon);
    KmatRecon(n,:,3) = interp1(IMETH.T,IMETH.KSA(n,:,3)*PROJdgn.rad*PROJdgn.kstep,SampRecon);
end
Kend = KmatRecon(:,end,:);

%---------------------------------------------
% Visuals
%---------------------------------------------
if strcmp(TST.KVis,'Yes') 
    figure(500);
    subplot(2,3,1);
    plot3(KmatRecon(1,:,1)/PROJdgn.kstep,KmatRecon(1,:,2)/PROJdgn.kstep,KmatRecon(1,:,3)/PROJdgn.kstep,'r-');
    lim = PROJdgn.rad;
    xlim([-lim,lim]); ylim([-lim,lim]); zlim([-lim,lim]);
    xlabel('kStep_x'); ylabel('kStep_y'); zlabel('kStep_z');
    set(gca,'cameraposition',[-31 -39 12.5]); 

    subplot(2,3,2); 
    Rad = sqrt(KmatRecon(:,:,1).^2 + KmatRecon(:,:,2).^2 + KmatRecon(:,:,3).^2);
    Rad = mean(Rad/PROJdgn.kmax,1);
    ind = find(Rad >= 2*PROJdgn.p,1);
    plot3(KmatRecon(1,1:ind,1)/PROJdgn.kstep,KmatRecon(1,1:ind,2)/PROJdgn.kstep,KmatRecon(1,1:ind,3)/PROJdgn.kstep,'r-');
    lim = ceil(PROJdgn.rad*2*PROJdgn.p);
    xlim([-lim,lim]); ylim([-lim,lim]); zlim([-lim,lim]);
    xlabel('kStep_x'); ylabel('kStep_y'); zlabel('kStep_z');
    set(gca,'cameraposition',[-31 -39 12.5]); 

    subplot(2,3,3);
    plot3(KmatRecon(1,:,1)/PROJdgn.kstep,KmatRecon(1,:,2)/PROJdgn.kstep,KmatRecon(1,:,3)/PROJdgn.kstep,'r-');
    lim = 0.5;
    xlim([-lim,lim]); ylim([-lim,lim]);
    xlabel('kStep_x'); ylabel('kStep_y'); zlabel('kStep_z');
    set(gca,'cameraposition',[0 0 5000]);
    set(gca,'CameraTargetMode','manual');
    set(gca,'CameraTarget',[0 0 0]);
    set(gca,'xtick',(-0.5:0.25:0.5)); set(gca,'ytick',(-0.5:0.25:0.5));    

end    
Kmat = KmatRecon;
samp = SampRecon;

KSMP.nproRecon = length(samp);

%---------------------------------------------
% Test
%---------------------------------------------
maxKend = max(abs(Kend(:)));    

%---------------------------------------------
% Test Max Relative Radial Sampling Step
%---------------------------------------------
Rad = sqrt(Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2);
rRad = Rad/PROJdgn.kstep;
KSMP.rRadFirstStepMean = mean(rRad(:,1));
KSMP.rRadSecondStepMean = mean(rRad(:,2)-rRad(:,1));
KSMP.rRadFirstStepMax = max(rRad(:,1));
for n = 2:KSMP.nproRecon
    rRadStep(:,n) = rRad(:,n) - rRad(:,n-1);
end
KSMP.rRadStepMax = max(rRadStep(:));
KSMP.meanrelkmax = mean(Rad(:,length(Rad(1,:))))/PROJdgn.kmax;
KSMP.maxrelkmax = max(Rad(:,length(Rad(1,:))))/PROJdgn.kmax;
KSMP.rSNR = 1;

%---------------------------------------------
% Return Sampling Timing for Testing
%---------------------------------------------
rKmag(1,:) = ((Kmat(1,:,1).^2 + Kmat(1,:,2).^2 + Kmat(1,:,3).^2).^(1/2))/PROJdgn.kmax;
KSMP.rKmag = mean(rKmag,1);
KSMP.tatr = SampRecon - SampRecon(1);    

%----------------------------------------------------
% Panel
%----------------------------------------------------
Panel(1,:) = {'npro',KSMP.nproRecon,'Output'};
Panel(2,:) = {'TotalDataPoints',KSMP.nproRecon*PROJimp.nproj,'Output'};
Panel(3,:) = {'rRadFirstStepMean',KSMP.rRadFirstStepMean,'Output'};
Panel(4,:) = {'rRadFirstStepMax',KSMP.rRadFirstStepMax,'Output'};
Panel(5,:) = {'rRadSecondStepMean',KSMP.rRadSecondStepMean,'Output'};
Panel(6,:) = {'rRadStepMax',KSMP.rRadStepMax,'Output'};
Panel(7,:) = {'meanrelkmax',KSMP.meanrelkmax,'Output'};
Panel(8,:) = {'rSNR',KSMP.rSNR,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);    
KSMP.PanelOutput = PanelOutput;     

%----------------------------------------------------
% Return
%----------------------------------------------------
IMETH.KSMP = KSMP;    
    
%----------------------------------------------------
% Other
%----------------------------------------------------
IMETH.samp = samp;
IMETH.Kmat = Kmat;

IMETH.PanelOutput = PanelOutput;  

sz = size(Kmat);
PROJimp.nproj = sz(1);
PROJimp.npro = sz(2);
PROJimp.meanrelkmax = 1;

IMETH.PROJimp = PROJimp;


Status2('done','',2);
Status2('done','',3);
    
    
