%=========================================================
% 
%=========================================================

function [IMP,err] = LR_INOVA_v1e_Func(INPUT)

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
PROJimp = INPUT.PROJimp;
NUC = INPUT.NUC;
SYS = INPUT.SYS;
GQNT = INPUT.GQNT;
GWFM = INPUT.GWFM;
PSMP = INPUT.PSMP;
TSMP = INPUT.TSMP;
KSMP = INPUT.KSMP;
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
% Testing
%------------------------------------------
TST.initstrght = 'No';
TST.constacc = 'Yes';    

%------------------------------------------
% Visualization 
%------------------------------------------
if strcmp(testingonly,'Yes');
    DES.SPIN.Vis = 'No';
    DES.CACC.Vis = 'No';   
    KSMP.Vis = 'Yes';
    GWFM.Vis = 'Yes';
else
    DES.SPIN.Vis = 'No';
    DES.CACC.Vis = 'No';   
    KSMP.Vis = 'Yes';
    GWFM.Vis = 'Yes';
end

%---------------------------------------------
% Generate Trajectories
%---------------------------------------------
Status('busy','Generate Trajectories');
INPUT = DES;
INPUT.PSMP = PSMP;
INPUT.TST = TST;
[OUTPUT,err] = genprojfunc(INPUT);
if err.flag
    return
end
T = OUTPUT.T;
KSA0 = OUTPUT.KSA;
clear INPUT;
if strcmp(testingonly,'Yes');
    testmaxsmpdwell = PROJdgn.kstep/max(OUTPUT.CACC.magvel);
    if testmaxsmpdwell ~= PROJdgn.maxsmpdwell;
        error();
    end
end
clear OUTPUT;
PROJimp.tro = PROJdgn.tro;
PROJimp.nproj = PROJdgn.nproj;
PROJimp.projosamp = PROJdgn.projosamp;

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

%---------------------------------------
% Visuals
%---------------------------------------
if strcmp(KSMP.Vis,'Yes')
    L = length(KSA(:,1,1));
    figure(2000); hold on; 
    plot(T(1,:),PROJdgn.kmax*KSA(1,:,1),'k-');     
    plot(T(1,:),PROJdgn.kmax*KSA(1,:,2),'k-');  
    plot(T(1,:),PROJdgn.kmax*KSA(1,:,3),'k-');
    title('Ksamp Traj1'); 
    xlabel('Time (ms)','fontsize',10,'fontweight','bold');
    ylabel('k-Space (1/m)','fontsize',10,'fontweight','bold');
    if L > 1
        figure(2001); hold on; 
        plot(T(ceil(L/4),:),PROJdgn.kmax*KSA(ceil(L/4),:,1),'k-');      
        plot(T(ceil(L/4),:),PROJdgn.kmax*KSA(ceil(L/4),:,2),'k-');  
        plot(T(ceil(L/4),:),PROJdgn.kmax*KSA(ceil(L/4),:,3),'k-');
        title(['Ksamp Traj',num2str(ceil(L/4))]);
        xlabel('Time (ms)','fontsize',10,'fontweight','bold');
        ylabel('k-Space (1/m)','fontsize',10,'fontweight','bold');    
        figure(2002); hold on; 
        plot(T(L-1,:),PROJdgn.kmax*KSA(L-1,:,1),'k-');      
        plot(T(L-1,:),PROJdgn.kmax*KSA(L-1,:,2),'k-');  
        plot(T(L-1,:),PROJdgn.kmax*KSA(L-1,:,3),'k-');
        title(['Ksamp Traj',num2str(L-1)]);
        xlabel('Time (ms)','fontsize',10,'fontweight','bold');
        ylabel('k-Space (1/m)','fontsize',10,'fontweight','bold');
    end
end

%----------------------------------------------------
% Get Nucleus Info
%----------------------------------------------------
Status('busy','Get Nucleus Info');
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
Status('busy','Solve Gradient Quantization Vector');
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
Status('busy','Create Gradient Waveforms');
func = str2func([PROJimp.gwfmfunc,'_Func']);
INPUT.GQNT = GQNT;
INPUT.SYS = SYS;
INPUT.PROJdgn = PROJdgn;
INPUT.PROJimp = PROJimp;
INPUT.T = T;
INPUT.KSA = KSA;
[GWFM,err] = func(GWFM,INPUT);
if err.flag
    return
end
clear INPUT
Gscnr = GWFM.Gscnr;
qTscnr = GWFM.qTscnr;

%----------------------------------------------------
% Define Trajectory Sampling
%----------------------------------------------------
Status('busy','Define Trajectory Sampling');
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
Status('busy','Resample k-Space');
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
Status('busy','Determine System Implementation Aspects');
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
GWFM = rmfield(GWFM,{'G0wend' 'qTwend' 'Gscnr' 'qTscnr' 'GQKSA'});
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


Status('done','');
Status2('done','',2);
Status2('done','',3);


