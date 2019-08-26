%=========================================================
% 
%=========================================================

function [IMP,err] = LR_INOVA_v1f_Func(INPUT)

Status('busy','Implement Trajectory Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
IMP = struct();

%---------------------------------------------
% Get Input
%---------------------------------------------
DES = INPUT.DES;
PROJdgn = DES.PROJdgn;
SPIN = DES.SPIN;
PROJimp = INPUT.PROJimp;
NUC = INPUT.NUC;
SYS = INPUT.SYS;
GQNT = INPUT.GQNT;
GWFM = INPUT.GWFM;
PSMP = INPUT.PSMP;
TSMP = INPUT.TSMP;
KSMP = INPUT.KSMP;
DESOL = INPUT.DESOL;
CACC = INPUT.CACC;
testingonly = INPUT.testingonly;
clear INPUT;

%---------------------------------------------
% Test for Common Routines
%---------------------------------------------
PROJimp.genprojfunc = PROJdgn.genprojfunc;
if not(exist(PROJimp.genprojfunc,'file'))
    err.flag = 1;
    err.msg = 'Folder of Common LR routines must be added to path';
    return
end
genprojfunc = str2func(PROJimp.genprojfunc);

%------------------------------------------
% Visualization 
%------------------------------------------
if strcmp(testingonly,'Yes');
    SPIN.Vis = 'No';
    CACC.Vis = 'Yes';
    DESOL.Vis = 'No';
    KSMP.Vis = 'Yes';
    GWFM.Vis = 'Yes';
else
    SPIN.Vis = 'No';
    CACC.Vis = 'No';
    DESOL.Vis = 'No';
    KSMP.Vis = 'Yes';
    GWFM.Vis = 'Yes';
end

%------------------------------------------
% Projection Sampling
%------------------------------------------
if strcmp(testingonly,'Yes');
    PSMP.phi = pi/2;
    PSMP.theta = 0;
    Panel(1,:) = {'ndiscs','Testing','Output'};
    PanelOutput = cell2struct(Panel,{'label','value','type'},2);
    PSMP.PanelOutput = PanelOutput;
else    
    INPUT.PROJdgn = PROJdgn;
    func = str2func([PROJimp.psmpfunc,'_Func']);           
    [PSMP,err] = func(PSMP,INPUT);
    if err.flag
        return
    end
    clear INPUT;
end

%------------------------------------------
% Get LR spinning functions
%------------------------------------------
INPUT.PROJdgn = PROJdgn;
func = str2func([PROJdgn.spinfunc,'_Func']);           
[SPIN,err] = func(SPIN,INPUT);
if err.flag
    return
end
clear INPUT;

%------------------------------------------
% Get radial evolution function for DE solution timing
%------------------------------------------
INPUT.PROJdgn = PROJdgn;
TST.initstrght = 'No';
INPUT.TST = TST;
func = str2func([PROJdgn.desoltimfunc,'_Func']);           
[DESOL,err] = func(DESOL,INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Generate Trajectories
%---------------------------------------------
INPUT.PROJdgn = PROJdgn;
INPUT.SPIN = SPIN;
INPUT.DESOL = DESOL;
INPUT.PSMP = PSMP;
TST.relprojlenmeas = 'No';
INPUT.TST = TST;
[OUTPUT,err] = genprojfunc(INPUT);
if err.flag
    return
end
KSA0 = OUTPUT.KSA;
T0 = OUTPUT.T;
clear INPUT;
clear OUTPUT;
PROJimp.tro = PROJdgn.tro;
PROJimp.nproj = PROJdgn.nproj;
PROJimp.projosamp = PROJdgn.projosamp;

%---------------------------------------------
% Test
%---------------------------------------------
%clf(figure(100));
%plot(T0,KSA0);

%------------------------------------------
% Constrain Accelerations
%------------------------------------------    
INPUT.kArr = squeeze(KSA0(1,:,:));
INPUT.TArr = T0;
INPUT.PROJdgn = PROJdgn;
INPUT.DESOL = DESOL;
INPUT.TST = TST;
func = str2func([PROJdgn.accconstfunc,'_Func']);  
[CACC,err] = func(CACC,INPUT);
if err.flag == 1
    return
end
clear INPUT;   
T = CACC.TArr;

impmaxsmpdwell = PROJdgn.kstep/max(CACC.magvel);
desmaxsmpdwell = PROJdgn.maxsmpdwell;
if impmaxsmpdwell > desmaxsmpdwell*1.02;
    error();
elseif impmaxsmpdwell < desmaxsmpdwell*0.98
    error();
end
    
%----------------------------------------------------
% Orient
%----------------------------------------------------
KSA = zeros(size(KSA0));
if strcmp(PROJimp.orient,'Axial');
    KSA(:,:,1) = KSA0(:,:,1);
    KSA(:,:,2) = KSA0(:,:,2);
    KSA(:,:,3) = KSA0(:,:,3);   
elseif strcmp(PROJimp.orient,'Sagittal');
    KSA(:,:,1) = KSA0(:,:,3);
    KSA(:,:,2) = KSA0(:,:,2);
    KSA(:,:,3) = KSA0(:,:,1);    
elseif strcmp(PROJimp.orient,'Coronal');
    KSA(:,:,1) = KSA0(:,:,1);
    KSA(:,:,2) = KSA0(:,:,3);
    KSA(:,:,3) = KSA0(:,:,2);  
end
clear KSA0;

%----------------------------------------------------
% Get Nucleus Info
%----------------------------------------------------
func = str2func([PROJimp.nucfunc,'_Func']);
INPUT = [];
[NUC,err] = func(NUC,INPUT);
if err.flag
    return
end
PROJimp.nucleus = NUC.nucleus;
PROJimp.gamma = NUC.gamma;

%----------------------------------------------------
% Solve Gradient Quantization Vector
%----------------------------------------------------
func = str2func([PROJimp.qvecslvfunc,'_Func']);
INPUT.PROJdgn = PROJdgn;
[GQNT,err] = func(GQNT,INPUT);
if err.flag
    return
end
clear INPUT
PROJimp.gseg = GQNT.gseg;
  
%---------------------------------------
% Create Gradient Waveforms
%---------------------------------------
func = str2func([PROJimp.gwfmfunc,'_Func']);
INPUT.GQNT = GQNT;
INPUT.SYS = SYS;
INPUT.PROJdgn = PROJdgn;
INPUT.PROJimp = PROJimp;
INPUT.T = T;
INPUT.KSA = KSA;
INPUT.PSMP = PSMP;
[GWFM,err] = func(GWFM,INPUT);
if err.flag
    return
end
clear INPUT
Gscnr = GWFM.Gscnr;
qTscnr = GWFM.qTscnr;
Grecon = GWFM.Grecon;
qTrecon = GWFM.qTrecon;

%---------------------------------------
% Visuals
%---------------------------------------
if strcmp(KSMP.Vis,'Yes')
    figure(2000); hold on; 
    plot(T,PROJdgn.kmax*KSA(GWFM.TstTrj,:,1),'k-');     
    plot(T,PROJdgn.kmax*KSA(GWFM.TstTrj,:,2),'k-');  
    plot(T,PROJdgn.kmax*KSA(GWFM.TstTrj,:,3),'k-');
    title(['Traj',num2str(GWFM.TstTrj)]);
    xlabel('Time (ms)','fontsize',10,'fontweight','bold');
    ylabel('k-Space (1/m)','fontsize',10,'fontweight','bold');
end

%----------------------------------------------------
% Define Trajectory Sampling
%----------------------------------------------------
func = str2func([PROJimp.tsmpfunc,'_Func']);
INPUT.PROJdgn = PROJdgn;
INPUT.PROJimp = PROJimp;
[TSMP,err] = func(TSMP,INPUT);
if err.flag
    ErrDisp(err);
    return
end
clear INPUT
PROJimp.npro = TSMP.npro;
PROJimp.sampstart = TSMP.sampstart;
PROJimp.dwell = TSMP.dwell;
PROJimp.trajosamp = TSMP.trajosamp;

%---------------------------------------
% Resample k-Space
%---------------------------------------
func = str2func([PROJimp.ksmpfunc,'_Func']);
INPUT.GWFM = GWFM;
INPUT.PROJimp = PROJimp;
INPUT.PROJdgn = PROJdgn;
[KSMP,err] = func(KSMP,INPUT);
if err.flag
    return
end
clear INPUT
samp = KSMP.samp;
Kmat = KSMP.Kmat;
PROJimp.meanrelkmax = KSMP.meanrelkmax;
PROJimp.maxrelkmax = KSMP.maxrelkmax;

%----------------------------------------------------
% Determine System Implementation Aspects
%----------------------------------------------------
func = str2func([PROJimp.sysimpfunc,'_Func']);
INPUT.PROJdgn = PROJdgn;
INPUT.GWFM = GWFM;
[SYS,err] = func(SYS,INPUT);
if err.flag
    return
end
clear INPUT

%--------------------------------------------
% Output Structure
%--------------------------------------------
GWFM = rmfield(GWFM,{'Gscnr' 'qTscnr' 'Grecon' 'qTrecon' 'GQKSA'});
KSMP = rmfield(KSMP,{'samp' 'Kmat' 'Kend'});
IMP.PROJimp = PROJimp;
IMP.impPROJdgn = PROJdgn;
IMP.SYS = SYS;
IMP.GQNT = GQNT;
IMP.PSMP = PSMP;
IMP.GWFM = GWFM;
IMP.TSMP = TSMP;
IMP.KSMP = KSMP;
IMP.samp = samp;
IMP.Kmat = Kmat;
IMP.qTscnr = qTscnr;
IMP.G = Gscnr;
IMP.qTrecon = qTrecon;
IMP.Grecon = Grecon;

Status('done','');
Status2('done','',2);
Status2('done','',3);


