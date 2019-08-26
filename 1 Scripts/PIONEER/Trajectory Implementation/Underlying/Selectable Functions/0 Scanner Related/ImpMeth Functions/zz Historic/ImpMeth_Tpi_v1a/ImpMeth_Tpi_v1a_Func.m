%=====================================================
% 
%=====================================================

function [IMETH,err] = ImpMeth_Tpi_v1a_Func(IMETH,INPUT)

Status2('busy','Implement for Design Testing',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test if Implementation Valid
%---------------------------------------------
if not(strcmp(INPUT.DES.type,'TPI'))
    err.flag = 1;
    err.msg = '''ImpMeth_Tpi...'' is not valid for the trajectory design';
    return
end

%---------------------------------------------
% Get Input
%---------------------------------------------
DES = INPUT.DES;
PROJdgn = DES.PROJdgn;
TPIT = DES.TPIT;
SYS = INPUT.SYS;
ORNT = IMETH.ORNT;
PROJimp = INPUT.PROJimp;
TST = INPUT.TST;
RADEV = IMETH.RADEV;
DESOL = IMETH.DESOL;
PSMP = IMETH.PSMP;
TSMP = IMETH.TSMP;
CACC = IMETH.CACC;
TEND = IMETH.TEND;
SYSRESP = IMETH.SYSRESP;
KSMP = IMETH.KSMP;
clear INPUT

%---------------------------------------------
% Test for Design Routine
%---------------------------------------------
if not(exist(DES.genprojfunc,'file'))
    error;
end
genprojfunc = str2func(DES.genprojfunc);

%---------------------------------------------
% Update Visualization from Test Function
%---------------------------------------------
if strcmp(IMETH.vis,'basic')
    KSMP.Vis = 'No';
    DESOL.Vis = 'No';
    CACC.Vis = 'No';
    SYSRESP.Vis = 'No'; 
    TST.GVis = 'No';
    TST.KVis = 'No';    
    TST.TVis = 'No';  
elseif strcmp(IMETH.vis,'gslew')
    KSMP.Vis = 'No';
    DESOL.Vis = 'No';
    CACC.Vis = 'ProfOnly';
    SYSRESP.Vis = 'No'; 
    TST.GVis = 'Yes';
    TST.KVis = 'No';    
    TST.TVis = 'No';     
else
    KSMP.Vis = TST.KSMP.Vis;
    DESOL.Vis = TST.DESOL.Vis;
    CACC.Vis = TST.CACC.Vis;
    SYSRESP.Vis = TST.SYSRESP.Vis;
end


%===============================================================================
% Test DE solution timing
%===============================================================================

%------------------------------------------
% Projection Sampling
%------------------------------------------
func = str2func([PSMP.method,'_Func']);
INPUT.PROJdgn = DES.PROJdgn;
INPUT.testing = 'Yes';  
[PSMP,err] = func(PSMP,INPUT);
if err.flag
    return
end
clear INPUT
PROJimp.projosamp = PSMP.projosamp;
PROJimp.nproj = PSMP.nproj;
IMETH.PSMP = PSMP;
IMETH.PROJimp = PROJimp;

%------------------------------------------
% Get radial evolution function 
%------------------------------------------
INPUT.PROJdgn = PROJdgn;
func = str2func([RADEV.method,'_Func']);           
[RADEV,err] = func(RADEV,INPUT);
if err.flag
    return
end
clear INPUT;
TST.relprojlenmeas = RADEV.relprojlenmeas;
TST.constevol = RADEV.constevol;

%------------------------------------------
% Get DE solution timing
%------------------------------------------
INPUT.PROJdgn = PROJdgn;
INPUT.RADEV = RADEV;
INPUT.TPIT = TPIT;
if strcmp(TST.testspeed,'Rapid')
    INPUT.courseadjust = 'yes';    
else
    INPUT.courseadjust = 'no';
end
func = str2func([DESOL.method,'_Func']);           
[DESOL,err] = func(DESOL,INPUT);
if err.flag
    return
end
clear INPUT;

%----------------------------------------------------
% Test Solution Fineness
%----------------------------------------------------    
INPUT.PROJdgn = PROJdgn;
INPUT.TPIT = TPIT;
INPUT.RADEV = RADEV;
INPUT.DESOL = DESOL;
INPUT.PSMP.phi = PSMP.phi(round(2*end/3));
INPUT.PSMP.theta = PSMP.theta(round(2*end/3));
INPUT.TST = TST;
[OUTPUT,err] = genprojfunc(INPUT);
if err.flag
    return
end
if strcmp(TST.relprojlenmeas,'Yes')
    if OUTPUT.projlen0 ~= PROJdgn.projlen0
        error
    end
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
if round(testtro*1e5) ~= round(PROJdgn.tro*1e5)
    error
end  

%---------------------------------------------
% Test
%---------------------------------------------
m = 2:length(KSA(1,:,1));
kStep = KSA(:,m,:) - KSA(:,m-1,:);              % assume first point at zero
MagkStep = sqrt(kStep(:,:,1).^2 + kStep(:,:,2).^2 + kStep(:,:,3).^2);
MagkStep = mean(MagkStep,1);
if Rad(end) < 1                                 % make sure not solved to less than 1
    RadEnd = Rad(end)
    error
end 

if strcmp(TST.TVis,'Yes')
    fh = figure(500); 
    fh.Name = 'Trajectory Testing';
    fh.NumberTitle = 'off';
    fh.Position = [260+TST.figshift 150 1400 800];
    subplot(2,3,1); hold on; axis equal; grid on; box off;
    plot3(PROJdgn.rad*KSA(1,:,1),PROJdgn.rad*KSA(1,:,2),PROJdgn.rad*KSA(1,:,3),'k-');
    lim = PROJdgn.rad;
    xlim([-lim,lim]); ylim([-lim,lim]); zlim([-lim,lim]);
    set(gca,'cameraposition',[-31 -39 12.5]); 
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

    subplot(2,3,3); hold on;
    plot(Rad(1:end-1),PROJdgn.rad*MagkStep,'k-');
    plot([PROJdgn.p PROJdgn.p],PROJdgn.rad*[0 1.1],':');
    plot([0 1],[0.1 0.1],':');
    plot([0 1],[1 1],':');
    ylim([0 1.1]);
    xlim([0 1]);
    xlabel('Relative Radius'); ylabel('kStep'); title('Solution Sampling Fineness');

    subplot(2,3,4); hold on;
    plot(Rad(1:end-1),PROJdgn.rad*MagkStep,'k-*');
    plot([PROJdgn.p PROJdgn.p],PROJdgn.rad*[0 1.1],':');
    plot([0 1],[0.1 0.1],':');
    plot([0 1],[1 1],':');
    ylim([0 0.15]);
    xlim([0 0.01]);
    xlabel('Relative Radius'); ylabel('kStep'); title('Solution Sampling Fineness');    
    
    if strcmp(TST.testspeed,'Rapid')
        button = questdlg('Continue? (This is a Course Solution for Testing)');
    else
        button = questdlg('Continue? (Check Solution Fineness for Waveform Generation)');
    end
    if not(strcmp(button,'Yes'))
        err.flag = 4;
        err.msg = '';
        return
    end    
end 
 

%===============================================================================
% Constrain Evolution
%===============================================================================

%----------------------------------------------------
% Generate
%----------------------------------------------------    
INPUT.PROJdgn = PROJdgn;
INPUT.TPIT = TPIT;
INPUT.RADEV = RADEV;
INPUT.DESOL = DESOL;
INPUT.PSMP.phi = PSMP.phi;
INPUT.PSMP.theta = PSMP.theta;
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
if round(testtro*1e5) ~= round(PROJdgn.tro*1e5)
    error
end

%---------------------------------------------
% Find 'hardest' trajectory
%---------------------------------------------
[vel,Tvel0] = CalcVelMulti_v2a(KSA*PROJdgn.kmax,T);
[acc,Tacc0] = CalcAccMulti_v2a(vel,Tvel0);
magacc0 = sqrt(acc(:,:,1).^2 + acc(:,:,2).^2 + acc(:,:,3).^2);
maxmagacc0 = max(magacc0,[],1);
ind = find(T > 1,1,'first');
maxtraj = find(magacc0(:,ind) == maxmagacc0(ind));

if strcmp(TST.TVis,'Yes')
    figure(500);
    subplot(2,3,5); hold on;
    plot(Tacc0,magacc0/PROJimp.gamma,'k-');
    plot(Tacc0,maxmagacc0/PROJimp.gamma,'b');
    plot(Tacc0,magacc0(maxtraj,:)/PROJimp.gamma,'r');
    xlabel('tro (ms)'); ylabel('Gradient Speed (mT/m/ms)'); title('Max Gradient Speed Test');
    xlim([0 PROJdgn.tro]);
    ylim([0 400]); 
end

%----------------------------------------------------
% Constrain Acceleration 
%----------------------------------------------------
INPUT.PROJdgn = PROJdgn;
INPUT.PROJimp = PROJimp;
INPUT.TST = TST;
INPUT.TArr = T;
INPUT.kArr = squeeze(KSA(maxtraj,:,:));
func = str2func([CACC.method,'_Func']);  
[CACC,err] = func(CACC,INPUT);
if err.flag ~= 0
    return
end
ConstEvolT = CACC.TArr;
ConstEvolRad = Rad;
clear INPUT;   

%---------------------------------------------
% Determine Initial Radial Speed
%---------------------------------------------    
ind = find(ConstEvolT > 1,1,'first');
GWFM.kRadAt1ms = Rad(ind)*PROJdgn.kmax;
ind = find(ConstEvolT > 0.3,1,'first');
GWFM.kRadAt03ms = Rad(ind)*PROJdgn.kmax;


%===============================================================================
% Generate Design
%===============================================================================

%----------------------------------------------------
% Projection Sampling
%----------------------------------------------------
func = str2func([PSMP.method,'_Func']);
INPUT.PROJdgn = DES.PROJdgn;
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

%----------------------------------------------------
% Generate
%----------------------------------------------------    
INPUT.PROJdgn = PROJdgn;
INPUT.TPIT = TPIT;
INPUT.RADEV = RADEV;
INPUT.DESOL = DESOL;
INPUT.PSMP = PSMP;
INPUT.TST = TST;
[OUTPUT,err] = genprojfunc(INPUT);
if err.flag
    return
end
KSA = OUTPUT.KSA;
clear INPUT;
clear OUTPUT;    

%---------------------------------------------------- 
% Test
%---------------------------------------------------- 
Rad = sqrt(KSA(:,:,1).^2 + KSA(:,:,2).^2 + KSA(:,:,3).^2);
Rad = mean(Rad,1);
if Rad(end) < 1                                 % make sure not solved to less than 1
    RadEnd = Rad(end)
    error
end    

%---------------------------------------------------- 
% Solve T at Evolution Constraint
%---------------------------------------------------- 
T = interp1(ConstEvolRad,ConstEvolT,Rad,'spline');

%---------------------------------------------------- 
% Test
%---------------------------------------------------- 
testtro = interp1(Rad,T,1,'spline'); 
if round(testtro*1e6) ~= round(PROJdgn.tro*1e6)
    error
end

%---------------------------------------------------- 
% Orient
%---------------------------------------------------- 
INPUT.PROJdgn = PROJdgn;
INPUT.KSA = KSA;
INPUT.SYS = SYS;
func = str2func([IMETH.orientfunc,'_Func']);           
[ORNT,err] = func(ORNT,INPUT);
if err.flag
    return
end
clear INPUT;
KSA = ORNT.KSA;
ORNT = rmfield(ORNT,'KSA');


%===============================================================================
% Build
%===============================================================================

%---------------------------------------------
% Quantize
%---------------------------------------------
qT0 = (0:SYS.GradSampBase/1000:PROJdgn.tro);
GQNT.divno = 1;
GQNT.mingseg = SYS.GradSampBase/1000;
GQNT.gseg = SYS.GradSampBase/1000;

%---------------------------------------------
% Test Quantization
%---------------------------------------------
if qT0(length(qT0)) ~= PROJdgn.tro 
    err.flag = 1;
    err.msg = 'Tro not a multiple of System Gseg';
    return
end

%---------------------------------------------
% Quantize Trajectories
%---------------------------------------------
Status2('busy','Quantize Trajectories',2);
nproj = length(KSA(:,1,1));
npg = length(qT0);
GQKSA0 = zeros(nproj,npg,3);
if nproj == 1
    for p = 1:3
        GQKSA0(1,:,p) = interp1(T,KSA(1,:,p),qT0,'spline','extrap');
    end
else  
    for n = 1:nproj
        for p = 1:3
            GQKSA0(n,:,p) = interp1(T,KSA(n,:,p),qT0,'spline','extrap');
        end
    end
end

%---------------------------------------------
% Test
%---------------------------------------------
m = 2:length(GQKSA0(1,:,1));
kStep = [GQKSA0(:,1,:) GQKSA0(:,m,:) - GQKSA0(:,m-1,:)];
MagkStep = sqrt(kStep(:,:,1).^2 + kStep(:,:,2).^2 + kStep(:,:,3).^2);
MagkStep = mean(MagkStep,1);
Rad = sqrt(GQKSA0(:,:,1).^2 + GQKSA0(:,:,2).^2 + GQKSA0(:,:,3).^2);
Rad = mean(Rad,1);
if round(Rad(end)*1e4) ~= 1e4 && not(strcmp(TST.testspeed,'Rapid'))
    test = round(Rad(end)*1e4)
    error
end     
GQKSA0 = PROJdgn.kmax*GQKSA0;

%----------------------------------------------------
% Delay Start (if necessary)
%----------------------------------------------------
Status2('busy','Delay Gradient Start',2);
func = str2func([SYSRESP.method,'_Func']);
INPUT.PROJimp = PROJimp;
INPUT.qT0 = qT0;
INPUT.GQKSA0 = GQKSA0;
INPUT.SYS = SYS;
INPUT.TST = TST;
INPUT.mode = 'Delay';
[SYSRESP,err] = func(SYSRESP,INPUT);
if err.flag
    return
end
qT = SYSRESP.qT;
GQKSA = SYSRESP.GQKSA;

%----------------------------------------------------
% Solve Gradient Quantization
%----------------------------------------------------
Status2('busy','Solve Gradient Quantization',2);
G0 = SolveGradQuant_v1b(qT,GQKSA,PROJimp.gamma);

%----------------------------------------------------
% Visuals
%----------------------------------------------------
if strcmp(TST.GVis,'Yes')
    [A,B,C] = size(G0);
    Gvis = zeros(A,B*2,C); L = zeros(1,B*2);
    for n = 1:length(qT)-1
        L((n-1)*2+1) = qT(n);
        L(n*2) = qT(n+1);
        Gvis(:,(n-1)*2+1,:) = G0(:,n,:);
        Gvis(:,n*2,:) = G0(:,n,:);
    end
    fhwfm = figure(1000); 
    fhwfm.Name = 'Gradient Waveforms';
    fhwfm.NumberTitle = 'off';
    fhwfm.Position = [460+TST.figshift 150 1000 800];
    subplot(2,2,1); hold on; 
    plot(L,zeros(size(L)),'k:');
    plot(L,Gvis(1,:,1),'b:'); plot(L,Gvis(1,:,2),'g:'); plot(L,Gvis(1,:,3),'r:');
    title(['Traj ',num2str(1)]);
    xlabel('(ms)','fontsize',10,'fontweight','bold');
    ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');   
end

%---------------------------------------------
% Calculate Gradient Momoments
%---------------------------------------------
Gmom = sum(G0,2)*(SYS.GradSampBase/1000);
Gend = G0(:,end,:);   

%----------------------------------------------------
% End Trajectory
%----------------------------------------------------
Status2('busy','End Trajectory',2);
func = str2func([TEND.method,'_Func']);
INPUT.SYS = SYS;
INPUT.Gmom = Gmom;  
INPUT.Gend = Gend;
INPUT.PROJimp = PROJimp;
INPUT.PROJdgn = PROJdgn;
[TEND,err] = func(TEND,INPUT);
if err.flag
    return
end    
Gend = TEND.Gend;
G0wend = cat(2,G0,Gend);
qTend = (GQNT.gseg:GQNT.gseg:length(Gend(1,:,1))*GQNT.gseg);
qTwend = [qT qT(end)+qTend];

%----------------------------------------------------
% Do Elip
%----------------------------------------------------
G0wend(:,:,ORNT.Zind) = G0wend(:,:,ORNT.Zind)*PROJdgn.elip;                             

%----------------------------------------------------
% Visuals
%----------------------------------------------------
if strcmp(TST.GVis,'Yes')
    [A,B,C] = size(G0wend);
    Gvis = zeros(A,B*2,C); L = zeros(1,B*2);
    for n = 1:length(qTwend)-1
        L((n-1)*2+1) = qTwend(n);
        L(n*2) = qTwend(n+1);
        Gvis(:,(n-1)*2+1,:) = G0wend(:,n,:);
        Gvis(:,n*2,:) = G0wend(:,n,:);
    end
    figure(1000); 
    subplot(2,2,1); hold on; 
    plot(L,zeros(size(L)),'k:');
    plot(L,Gvis(1,:,1),'b:'); plot(L,Gvis(1,:,2),'g:'); plot(L,Gvis(1,:,3),'r:');
    title(['Traj ',num2str(1)]);
    xlabel('(ms)','fontsize',10,'fontweight','bold');
    ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');   
end

%----------------------------------------------------
% Calculate Relevant Gradient Amplifier Parameters
%----------------------------------------------------
Status2('busy','Calculate Relevant Gradient Amplifier Parameters',2);
m = (2:length(G0wend(1,:,1))-2);
cartgsteps = [G0wend(:,1,:) G0wend(:,m,:)-G0wend(:,m-1,:)];
maxmaggsteps = max(((cartgsteps(:,:,1).^2 + cartgsteps(:,:,2).^2 + cartgsteps(:,:,3).^2).^0.5),[],1);
cartg2drv =  [cartgsteps(:,1,:) cartgsteps(:,m,:)-cartgsteps(:,m-1,:)];
if strcmp(TST.GVis,'Yes') 
    figure(1000); 
    subplot(2,2,2); hold on; 
    for p = 1:length(cartgsteps(1,:,1))
        maxcartgsteps(p) = max(max(abs(cartgsteps(:,p,:))));
    end
    GWFM.G0wendmaxcartslew = max(maxcartgsteps)/GQNT.gseg;
    plot(qTwend(2:length(qTwend)-2),maxcartgsteps/GQNT.gseg,'y-');
    plot(qTwend(2:length(qTwend)-2),maxmaggsteps/GQNT.gseg,'y:');
    title('Max Gradient Speed');
    ylabel('Gradient Speed (mT/m/ms)','fontsize',10,'fontweight','bold');
    xlabel('(ms)','fontsize',10,'fontweight','bold');
    figure(1000); 
    subplot(2,2,3); hold on; 
    for p = 1:length(cartg2drv(1,:,1))
        maxcartg2drvT(p) = max(max(abs(cartg2drv(:,p,:))));
    end
    GWFM.G0wendmaxcart2drv = max(maxcartg2drvT(2:length(qT)-1))/GQNT.gseg^2;
    plot(qTwend(2:length(qT)-1),maxcartg2drvT(2:length(qT)-1)/GQNT.gseg^2,'y-');
    title('Max Gradient Channel Acceleration');
    ylabel('Gradient Acceleration (mT/m/ms2)','fontsize',10,'fontweight','bold');
    xlabel('(ms)','fontsize',10,'fontweight','bold');    
end     

%----------------------------------------------------
% Compensate for System Response
%----------------------------------------------------
Status2('busy','Compensate for System Response',2);
func = str2func([SYSRESP.method,'_Func']);
INPUT.PROJimp = PROJimp;
INPUT.qT0 = qTwend;
INPUT.G0 = G0wend;
INPUT.SYS = SYS;
INPUT.TST = TST;
INPUT.mode = 'Compensate';
[SYSRESP,err] = func(SYSRESP,INPUT);
if err.flag
    return
end
Gcomp = SYSRESP.Gcomp;    
qTcomp = SYSRESP.Tcomp;
GWFM.sampend = PROJdgn.tro + SYSRESP.efftrajdel;     

%----------------------------------------------------
% Visuals
%----------------------------------------------------
if strcmp(TST.GVis,'Yes') 
    [A,B,C] = size(Gcomp);
    Gvis = zeros(A,B*2,C); L = zeros(1,B*2);
    for n = 1:length(qTcomp)-1
        L((n-1)*2+1) = qTcomp(n);
        L(n*2) = qTcomp(n+1);
        Gvis(:,(n-1)*2+1,:) = Gcomp(:,n,:);
        Gvis(:,n*2,:) = Gcomp(:,n,:);
    end
    figure(1000); 
    subplot(2,2,1); hold on; 
    plot(L,Gvis(1,:,1),'b-'); plot(L,Gvis(1,:,2),'g-'); plot(L,Gvis(1,:,3),'r-');
    title(['Traj',num2str(1)]);
    xlabel('(ms)','fontsize',10,'fontweight','bold');
    ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
end    

%----------------------------------------------------
% Calculate Acoustic Frequency Response
%----------------------------------------------------    
if strcmp(TST.GVis,'Yes') 
    Glen = length(Gcomp(1,:,1));
    zfGcompX = zeros(1,10000);
    zfGcompY = zeros(1,10000);
    zfGcompZ = zeros(1,10000);    
    zfGcompX(1:Glen) = squeeze(Gcomp(1,:,1)); 
    zfGcompY(1:Glen) = squeeze(Gcomp(1,:,2)); 
    zfGcompZ(1:Glen) = squeeze(Gcomp(1,:,3));     
    ftGcompX = abs(fftshift(fft(zfGcompX)));
    ftGcompY = abs(fftshift(fft(zfGcompY)));
    ftGcompZ = abs(fftshift(fft(zfGcompZ)));    
    figure(1000); 
    subplot(2,2,4); hold on; 
    fstep = 1/(10000*GQNT.gseg);
    freq = (-1/(2*GQNT.gseg):fstep:(1/(2*GQNT.gseg))-fstep);
    freq = freq*1000;
    RefSin = 30*sin(1000*2*pi*qTcomp(1:end-1)/1000);
    zfRefSin = zeros(1,10000);
    zfRefSin(1:Glen) = RefSin;
    ftRefSin = abs(fftshift(fft(zfRefSin)));
    plot(freq,ftRefSin/max(ftRefSin(:)),'k');
    plot(freq,ftGcompX/max(ftRefSin(:)),'b-'); plot(freq,ftGcompY/max(ftRefSin(:)),'g-'); plot(freq,ftGcompZ/max(ftRefSin(:)),'r-');    
    title('Acoustic Resonance (Relative to 30 mT/m Sinusoid at 1000 Hz)');
    xlabel('(Hz)','fontsize',10,'fontweight','bold');
    ylabel('Relative Magnitude','fontsize',10,'fontweight','bold');
    xlim([0 2000]);
    plot([SYS.AcousticFreqsCen(1)-SYS.AcousticFreqsHBW(1) SYS.AcousticFreqsCen(1)-SYS.AcousticFreqsHBW(1)],[0 1],'k:');
    plot([SYS.AcousticFreqsCen(1)+SYS.AcousticFreqsHBW(1) SYS.AcousticFreqsCen(1)+SYS.AcousticFreqsHBW(1)],[0 1],'k:');
    plot([SYS.AcousticFreqsCen(2)-SYS.AcousticFreqsHBW(2) SYS.AcousticFreqsCen(2)-SYS.AcousticFreqsHBW(2)],[0 1],'k:');
    plot([SYS.AcousticFreqsCen(2)+SYS.AcousticFreqsHBW(2) SYS.AcousticFreqsCen(2)+SYS.AcousticFreqsHBW(2)],[0 1],'k:');
end
    
%----------------------------------------------------
% Calculate Relevant Gradient Amplifier Parameters
%----------------------------------------------------
Status2('busy','Calculate Relevant Gradient Amplifier Parameters',2);
m = (2:length(Gcomp(1,:,1))-2);
cartgsteps = [Gcomp(:,1,:) Gcomp(:,m,:)-Gcomp(:,m-1,:)];
maxmaggsteps = max(((cartgsteps(:,:,1).^2 + cartgsteps(:,:,2).^2 + cartgsteps(:,:,3).^2).^0.5),[],1);
cartg2drv =  [cartgsteps(:,1,:) cartgsteps(:,m,:)-cartgsteps(:,m-1,:)];
for p = 1:length(cartgsteps(1,:,1))
    maxcartgsteps(p) = max(max(abs(cartgsteps(:,p,:))));
end
maxcartgsteps = smooth(maxcartgsteps,7);
GWFM.Gcompmaxcartslew = max(maxcartgsteps)/GQNT.gseg;
for p = 1:length(cartg2drv(1,:,1))
    maxcartg2drvT(p) = max(max(abs(cartg2drv(:,p,:))));
end
maxcartg2drvT = smooth(maxcartg2drvT,7);
GWFM.Gcompmaxcart2drv = max(maxcartg2drvT(2:length(qT)-1))/GQNT.gseg^2;

if strcmp(TST.GVis,'Yes') 
    figure(1000); 
    subplot(2,2,2); hold on; 
    sp3 = plot(qTcomp(2:length(qTcomp)-2),maxcartgsteps/GQNT.gseg,'k-');
    sp4 = plot(qTcomp(2:length(qTcomp)-2),maxmaggsteps/GQNT.gseg,'k:');
    title('Max Gradient Speed');
    ylabel('Gradient Speed (mT/m/ms)','fontsize',10,'fontweight','bold');
    xlabel('(ms)','fontsize',10,'fontweight','bold');
    legend([sp3,sp4],'Max Channel Speed','Mean Total Speed','Location','southwest');
    
    subplot(2,2,3); hold on; 
    plot(qTcomp(2:length(qT)-1),maxcartg2drvT(2:length(qT)-1)/GQNT.gseg^2,'k-');
    title('Max Gradient Channel Acceleration');
    ylabel('Gradient Acceleration (mT/m/ms2)','fontsize',10,'fontweight','bold');
    xlabel('(ms)','fontsize',10,'fontweight','bold');    
end     

%----------------------------------------------------
% Gradient Abs Test
%----------------------------------------------------    
GmaxSncrChan = max(abs(Gcomp(:)));

%----------------------------------------------------
% Max Sampled Gradient
%----------------------------------------------------            
GabsTraj = sqrt(G0(:,:,1).^2 + G0(:,:,2).^2 + G0(:,:,3).^2);   
GmaxTraj = max(GabsTraj(:));

%----------------------------------------------------
% Save
%----------------------------------------------------
GWFM.GmaxTraj = GmaxTraj;
GWFM.GmaxSncrChan = GmaxSncrChan;
GWFM.tgwfm = qTcomp(length(qTcomp));
IMETH.Gscnr = Gcomp;
IMETH.qTscnr = qTcomp;
IMETH.tgwfm = GWFM.tgwfm;

%----------------------------------------------------
% Panel Output
%----------------------------------------------------
GwfmPanel(1,:) = {'GmaxChan (amp)',GWFM.GmaxSncrChan,'Output'};
GwfmPanel(2,:) = {'GmaxChanSlew (amp)',GWFM.Gcompmaxcartslew,'Output'};
GwfmPanel(3,:) = {'GmaxChan2Drv (amp)',GWFM.Gcompmaxcart2drv,'Output'};
GwfmPanel(4,:) = {'kRadAt1ms (1/m)',GWFM.kRadAt1ms,'Output'};
GwfmPanel(5,:) = {'kRadAt03ms (1/m)',GWFM.kRadAt03ms,'Output'};
GwfmPanel(6,:) = {'tgwfm (ms)',IMETH.tgwfm,'Output'};


%===============================================================================
% TrajSamp
%===============================================================================
func = str2func([TSMP.method,'_Func']);
INPUT.PROJdgn = PROJdgn;
INPUT.PROJimp = PROJimp;
INPUT.GWFM = GWFM;
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
PROJimp.npro = TSMP.npro;


%===============================================================================
% Recon
%===============================================================================

%----------------------------------------------------
% Add Transient Response Effect
%----------------------------------------------------
Status2('busy','Include Transient Response Effect',2);
func = str2func([SYSRESP.method,'_Func']);
INPUT.PROJimp = PROJimp;
INPUT.qT0 = IMETH.qTscnr;
INPUT.G0 = IMETH.Gscnr;
INPUT.SYS = SYS;
INPUT.TST = TST;
INPUT.mode = 'Analyze';
[SYSRESP,err] = func(SYSRESP,INPUT);
if err.flag
    return
end
Grecon = SYSRESP.Grecon;  
qTrecon = SYSRESP.Trecon;

%----------------------------------------------------
% Visuals
%----------------------------------------------------
if strcmp(TST.GVis,'Yes') 
    [A,B,C] = size(Grecon);
    Gvis = zeros(A,B*2,C); L = zeros(1,B*2);
    for n = 1:length(qTrecon)-1
        L((n-1)*2+1) = qTrecon(n);
        L(n*2) = qTrecon(n+1);
        Gvis(:,(n-1)*2+1,:) = Grecon(:,n,:);
        Gvis(:,n*2,:) = Grecon(:,n,:);
    end
    figure(1000); 
    subplot(2,2,1); hold on; 
    plot(L,Gvis(1,:,1),'b-'); plot(L,Gvis(1,:,2),'g-'); plot(L,Gvis(1,:,3),'r-');
    xlim([L(1) L(end)]);
    title(['Traj',num2str(1)]);
    xlabel('(ms)','fontsize',10,'fontweight','bold');
    ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
end

%----------------------------------------------------
% Resample k-Space
%----------------------------------------------------
Status2('busy','Resample k-Space',2);
func = str2func([KSMP.method,'_Func']);
INPUT.PROJimp = PROJimp;
INPUT.qTrecon = qTrecon;
INPUT.Grecon = Grecon;
INPUT.TSMP = TSMP;
INPUT.SYSRESP = SYSRESP;
INPUT.SYS = SYS;
[KSMP,err] = func(KSMP,INPUT);
if err.flag
    return
end
Samp0 = KSMP.Samp0;  
Kmat0 = KSMP.Kmat0;    
SampRecon = KSMP.SampRecon;  
KmatRecon = KSMP.KmatRecon;   
Kend = KSMP.Kend;  
KSMP = rmfield(KSMP,{'Samp0','Kmat0','SampRecon','KmatRecon','Kend'}); 

%---------------------------------------------
% Visuals
%---------------------------------------------
if strcmp(TST.KVis,'Yes') 

    fhk = figure(3000); clf;
    fhk.Name = 'kSpace Sampling';
    fhk.NumberTitle = 'off';
    fhk.Position = [260+TST.figshift 150 1400 800];
    subplot(2,3,1); hold on; 
    p1 = plot(Samp0,Kmat0(1,:,1),'k-'); plot(Samp0,Kmat0(1,:,2),'k-'); plot(Samp0,Kmat0(1,:,3),'k-');
    p2 = plot(SampRecon,KmatRecon(1,:,1),'b-'); plot(SampRecon,KmatRecon(1,:,2),'g-'); plot(SampRecon,KmatRecon(1,:,3),'r-');
    p3 = plot(qT,GQKSA(1,:,1),'b*'); plot(qT,GQKSA(1,:,2),'g*'); plot(qT,GQKSA(1,:,3),'r*');
    xlabel('Sampling Time (ms)'); ylabel('kSpace (1/m)'); title('System Response Compensation Test');
    legend([p1,p2,p3],'Full','Recon','GQKSA','location','southwest');

    subplot(2,3,2); hold on;
    Status2('busy','Test k-Space Error',2);
    [testK,~] = ReSampleKSpace_v7a(Grecon,qTrecon-qTrecon(1),qT-qTrecon(1),PROJimp.gamma);
    Kerr = testK - GQKSA;
    maxKerr = squeeze(max(Kerr,[],1));
    plot(qT,maxKerr(:,1),'b'); plot(qT,maxKerr(:,2),'g'); plot(qT,maxKerr(:,3),'r');
    xlabel('Sampling Time (ms)'); ylabel('kSpace (1/m)'); title('Max TrajComp Error @ qT'); ylim([-0.05 0.05]);

    subplot(2,3,3); hold on;
    pts = 50;
    plot(KmatRecon(1,1:pts,1)/PROJdgn.kstep,'b*'); plot(KmatRecon(1,1:pts,2)/PROJdgn.kstep,'g*'); plot(KmatRecon(1,1:pts,3)/PROJdgn.kstep,'r*');    
    xlim([0 pts]);
    xlabel('Sampling Points'); ylabel('kSpace Steps'); title('Initial Sampled Points');

    subplot(2,3,4); hold on;
    if length(Kend(:,1,1)) == 1
        plot(Kend(:,1,1),'b*'); plot(Kend(:,1,2),'g*'); plot(Kend(:,1,3),'r*');
    else
        plot(Kend(:,1,1),'b'); plot(Kend(:,1,2),'g'); plot(Kend(:,1,3),'r');
    end
    xlabel('trajectory'); ylabel('kSpace (1/m)'); title('Trajectory End');

    subplot(2,3,5); hold on;
    ind1 = find(abs(Kend(:,1,1)) == max(abs(Kend(:,1,1))));
    ind2 = find(abs(Kend(:,1,2)) == max(abs(Kend(:,1,2))));
    ind3 = find(abs(Kend(:,1,3)) == max(abs(Kend(:,1,3))));
    plot(T,PROJdgn.kmax*KSA(ind1,:,1),'k'); plot(Samp0,Kmat0(ind1,:,1),'b');
    plot(T,PROJdgn.kmax*KSA(ind2,:,2),'k'); plot(Samp0,Kmat0(ind2,:,2),'g');
    plot(T,PROJdgn.kmax*KSA(ind3,:,3),'k'); plot(Samp0,Kmat0(ind3,:,3),'r');
    xlabel('trajectory'); ylabel('kSpace (1/m)'); title('Waveforms with Greatest kEnd');
end    
Kmat = KmatRecon;
samp = SampRecon;

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

%---------------------------------------------
% Return Sampling Timing for Testing
%---------------------------------------------
rKmag(1,:) = ((Kmat(1,:,1).^2 + Kmat(1,:,2).^2 + Kmat(1,:,3).^2).^(1/2))/PROJdgn.kmax;
KSMP.rKmag = mean(rKmag,1);
KSMP.tatr = SampRecon - SampRecon(1);    

%----------------------------------------------------
% Other
%----------------------------------------------------
KSMP.maxfreq = GWFM.GmaxTraj*PROJimp.gamma*PROJdgn.fov/2;
IMETH.samp = samp;
IMETH.Kmat = Kmat;
IMETH.Kend = Kend;
KSMP.maxKend = maxKend;  

%----------------------------------------------------
% Fix up (from dropping points at beginning)
%----------------------------------------------------
PROJimp.npro = KSMP.nproRecon;
PROJimp.tro = KSMP.nproRecon*TSMP.dwell;

%----------------------------------------------------
% Panel
%----------------------------------------------------
KsmpPanel(1,:) = {'troTotal (ms)',KSMP.nproRecon*TSMP.dwell,'Output'};
KsmpPanel(2,:) = {'npro',KSMP.nproRecon,'Output'};
KsmpPanel(3,:) = {'TotalDataPoints',KSMP.nproRecon*PROJimp.nproj,'Output'};
KsmpPanel(4,:) = {'rRadFirstStepMean',KSMP.rRadFirstStepMean,'Output'};
KsmpPanel(5,:) = {'rRadSecondStepMean',KSMP.rRadSecondStepMean,'Output'};

PanelSpace(1,:) = {'','','Output'};
if strcmp(IMETH.vis,'basic') || strcmp(IMETH.vis,'gslew')
    IMETH.Panel = [PanelSpace;GwfmPanel];
else
    IMETH.Panel = [PanelSpace;GwfmPanel;PanelSpace;TSMP.Panel;PanelSpace;KsmpPanel];
end

%----------------------------------------------------
% Basic Figure
%----------------------------------------------------
fh = figure(23457); 
fh.Name = 'Waveform Display';
fh.NumberTitle = 'off';
fh.Position = [260+TST.figshift 300 1400 400];
subplot(1,3,1); hold on; axis equal; grid on; box off;
set(gca,'cameraposition',[-400 -500 80]); 
plot3(Kmat(1,:,1),Kmat(1,:,2),Kmat(1,:,3),'k-');
lim = PROJdgn.kmax;
xlim([-lim,lim]); ylim([-lim,lim]); zlim([-lim,lim]);
xlabel('k_x (1/m)'); ylabel('k_y (1/m)'); zlabel('k_z (1/m)'); title('Final Trajectory');

subplot(1,3,2); hold on;
plot(samp,Kmat(1,:,1),'b');
plot(samp,Kmat(1,:,2),'g');
plot(samp,Kmat(1,:,3),'r');
plot([0 PROJdgn.tro],[0 0],':');
xlim([0,PROJdgn.tro]);
ylim([-lim,lim]);
xlabel('time (ms)');
ylabel('k (1/m)');
title('Final Trajectory');

subplot(1,3,3); hold on;
[A,B,C] = size(IMETH.Gscnr);
Gvis = zeros(A,B*2,C); L = zeros(1,B*2);
for n = 1:length(IMETH.qTscnr)-1
    L((n-1)*2+1) = IMETH.qTscnr(n);
    L(n*2) = IMETH.qTscnr(n+1);
    Gvis(:,(n-1)*2+1,:) = IMETH.Gscnr(:,n,:);
    Gvis(:,n*2,:) = IMETH.Gscnr(:,n,:);
end
plot(L,Gvis(1,:,1),'b');
plot(L,Gvis(1,:,2),'g');
plot(L,Gvis(1,:,3),'r');
plot([0 IMETH.tgwfm],[0 0],':');
xlim([0,IMETH.tgwfm]);
lim = GWFM.GmaxTraj;
ylim([-lim,lim]);
xlabel('time (ms)');
ylabel('Gradient (mT/m)');
title('Gradient Waveform');

%----------------------------------------------------
% Return
%----------------------------------------------------
GWFM.ORNT = ORNT;
IMETH.GWFM = GWFM; 
IMETH.PSMP = PSMP;
IMETH.TSMP = TSMP;
IMETH.KSMP = KSMP;
IMETH.impPROJdgn = PROJdgn;
IMETH.PROJimp = PROJimp;

Status2('done','',2);
Status2('done','',3);
    
    
