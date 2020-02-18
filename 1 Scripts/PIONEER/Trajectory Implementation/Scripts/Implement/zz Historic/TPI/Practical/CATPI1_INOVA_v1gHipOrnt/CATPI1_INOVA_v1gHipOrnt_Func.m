%=========================================================
% 
%=========================================================

function [IMP,err] = CATPI1_INOVA_v1gHipOrnt_Func(INPUT)

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
GAMFUNC = DES.GAMFUNC;
PROJimp = INPUT.PROJimp;
SYS = INPUT.SYS;
GQNT = INPUT.GQNT;
GWFM = INPUT.GWFM;
PSMP = INPUT.PSMP;
TSMP = INPUT.TSMP;
KSMP = INPUT.KSMP;
testing = INPUT.testingonly;
clear INPUT;
clear DES;

%---------------------------------------------
% Test for Common Routines
%---------------------------------------------
PROJimp.genfunc = 'TPI_GenProj_v3c';
if not(exist(PROJimp.genfunc,'file'))
    err.flag = 1;
    err.msg = 'Folder of Common TPI routines must be added to path';
    return
end

%----------------------------------------------------
% Check
%----------------------------------------------------
if not(isfield(PROJdgn,'iseg'))
    err.flag = 1;
    err.msg = 'Design / Implementation Not Compatible';
    return
end 

%----------------------------------------------------
% CATPI Related
%----------------------------------------------------
PROJdgn0 = PROJdgn;
PROJdgn0.iseg = PROJimp.iseg;

%----------------------------------------------------
% Solve Gradient Quantization Vector
%----------------------------------------------------
Status('busy','Solve Gradient Quantization Vector');
func = str2func([PROJimp.qvecslvfunc,'_Func']);
INPUT.PROJdgn = PROJdgn0;
INPUT.PROJimp = PROJimp;
INPUT.mode = 'FindBest';
[GQNT0,err] = func(GQNT,INPUT);
if err.flag
    return
end
clear INPUT
PROJimp.tro = GQNT0.besttro;
PROJimp.iseg = GQNT0.bestiseg;
PROJimp.twseg = GQNT0.besttwseg;

%----------------------------------------------------
% CATPI Related - Recalculate 'projlen' for new 'tro'
%----------------------------------------------------
impPROJdgn = PROJdgn;
tro = PROJimp.tro;
tro0 = 0;
while ceil(tro*1000) ~= ceil(tro0*1000)
    impPROJdgn.tro = PROJimp.tro + impPROJdgn.iseg - PROJimp.iseg; 
    Status('busy','Determine Effect of Design Tweak');
    func = str2func([PROJdgn.method,'_Func']);
    INPUT.PROJdgn = impPROJdgn;
    INPUT.GAMFUNC = GAMFUNC;
    [DES,err] = func(INPUT);
    if err.flag ~= 0
        return
    end
    impPROJdgn = DES.PROJdgn;
    tro0 = tro;
    tro = impPROJdgn.tro;
end
clear INPUT
clear DES

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'iSeg (ms)',impPROJdgn.iseg,'Output'};
Panel(2,:) = {'Tro (ms)',impPROJdgn.tro,'Output'};
Panel(3,:) = {'ProjLen',impPROJdgn.projlen,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
impPROJdgn.PanelOutput = PanelOutput;

%----------------------------------------------------
% Determine System Implementation Aspects
%----------------------------------------------------
Status('busy','Determine System Implementation Aspects');
func = str2func([PROJimp.sysimpfunc,'_Func']);
INPUT.PROJdgn = impPROJdgn;
INPUT.twwords = GQNT0.twwords;
[SYS,err] = func(SYS,INPUT);
if err.flag
    return
end
clear INPUT

%----------------------------------------------------
% Define Projection Sampling
%----------------------------------------------------
Status('busy','Define Projection Sampling');
func = str2func([PROJimp.psmpfunc,'_Func']);
INPUT.PROJdgn = impPROJdgn;
INPUT.testing = testing;
[PSMP,err] = func(PSMP,INPUT);
if err.flag
    return
end
clear INPUT
PROJimp.projosamp = PSMP.projosamp;
PROJimp.nproj = PSMP.nproj;

%----------------------------------------------------
% Generate Projections
%----------------------------------------------------
Status('busy','Generate Trajectories');
func = str2func(PROJimp.genfunc);
ImpStrct.slvno = PROJimp.slvno;
ImpStrct.IV = PSMP.IV;
[T,KSA0,err] = func(impPROJdgn,GAMFUNC,ImpStrct);
if err.flag
    return
end

%----------------------------------------------------
% Orient
%----------------------------------------------------
KSA01 = zeros(size(KSA0));
KSA01(:,:,1) = KSA0(:,:,1);               % coronal
KSA01(:,:,2) = KSA0(:,:,3);
KSA01(:,:,3) = KSA0(:,:,2);  

KSA = zeros(size(KSA01));
thx = (pi*PROJimp.hippoangle/180);
Rx=[1 0 0;
    0 cos(thx) -sin(thx);
    0 sin(thx) cos(thx)];
sz = size(KSA0);
for n = 1:sz(1)
    KSA(n,:,:) = squeeze(KSA01(n,:,:))*Rx;
end
% 
%----------------------------------------------------
% Test/Build Quantization Vector
%----------------------------------------------------
Status('busy','Build Quantization Vector');
func = str2func([PROJimp.qvecslvfunc,'_Func']);
INPUT.PROJdgn = impPROJdgn;
INPUT.PROJimp = PROJimp;
INPUT.mode = 'Output';
[GQNT,err] = func(GQNT,INPUT);
if err.flag
    return
end
clear INPUT
if GQNT.tro ~= PROJimp.tro || GQNT.iseg ~= PROJimp.iseg || GQNT.twseg ~= PROJimp.twseg
    error();
end

%----------------------------------------------------
% CATPI Related
%----------------------------------------------------
GQNT.samparr = [0 impPROJdgn.iseg (impPROJdgn.iseg+GQNT.twseg:GQNT.twseg:impPROJdgn.tro+0.001)];
testtro = GQNT.samparr(length(GQNT.samparr));
if round(testtro*10000) ~= round(impPROJdgn.tro*10000)  
    round(testtro*10000)
    round(impPROJdgn.tro*10000)
    error();
end

%---------------------------------------
% Create Gradient Waveforms
%---------------------------------------
Status('busy','Create Gradient Waveforms');
func = str2func([PROJimp.gwfmfunc,'_Func']);
INPUT.GQNT = GQNT;
INPUT.SYS = SYS;
INPUT.PROJdgn = impPROJdgn;
INPUT.PROJimp = PROJimp;
INPUT.T = T;
INPUT.KSA = KSA;
[GWFM,err] = func(GWFM,INPUT);
if err.flag
    return
end
clear INPUT
G = GWFM.G;

%---------------------------------------
% Check if Projection Sampling Still Sufficient
%---------------------------------------
%if GWFM.rIovershoot > PSMP.osamp_theta
%    err.flag = 1;
%    err.msg = 'increase osamp_theta';
%    return
%end

%---------------------------------------
% Visuals
%---------------------------------------
kVis = 'On';
if strcmp(kVis,'On') 
    [L,~,~] = size(GWFM.GQKSA);
    figure(2000); hold on; 
    plot(GQNT.scnrarr,GWFM.GQKSA(1,:,1),'b-'); plot(impPROJdgn.tro*T(1,:)/impPROJdgn.projlen,impPROJdgn.kmax*KSA(1,:,1),'k-');     
    plot(GQNT.scnrarr,GWFM.GQKSA(1,:,2),'g-'); plot(impPROJdgn.tro*T(1,:)/impPROJdgn.projlen,impPROJdgn.kmax*KSA(1,:,2),'k-');  
    plot(GQNT.scnrarr,GWFM.GQKSA(1,:,3),'r-'); plot(impPROJdgn.tro*T(1,:)/impPROJdgn.projlen,impPROJdgn.kmax*KSA(1,:,3),'k-');
    title('Ksamp Traj1'); 
    xlabel('Time (ms)','fontsize',10,'fontweight','bold');
    ylabel('k-Space (1/m)','fontsize',10,'fontweight','bold');
    figure(2001); hold on; 
    plot(GQNT.scnrarr,GWFM.GQKSA(round(L/4),:,1),'b-'); plot(impPROJdgn.tro*T(1,:)/impPROJdgn.projlen,impPROJdgn.kmax*KSA(round(L/4),:,1),'k-');      
    plot(GQNT.scnrarr,GWFM.GQKSA(round(L/4),:,2),'g-'); plot(impPROJdgn.tro*T(1,:)/impPROJdgn.projlen,impPROJdgn.kmax*KSA(round(L/4),:,2),'k-');  
    plot(GQNT.scnrarr,GWFM.GQKSA(round(L/4),:,3),'r-'); plot(impPROJdgn.tro*T(1,:)/impPROJdgn.projlen,impPROJdgn.kmax*KSA(round(L/4),:,3),'k-');
    title(['Ksamp Traj',num2str(round(L/4))]);
    xlabel('Time (ms)','fontsize',10,'fontweight','bold');
    ylabel('k-Space (1/m)','fontsize',10,'fontweight','bold');    
    figure(2002); hold on; 
    plot(GQNT.scnrarr,GWFM.GQKSA(L-1,:,1),'b-'); plot(impPROJdgn.tro*T(1,:)/impPROJdgn.projlen,impPROJdgn.kmax*KSA(L-1,:,1),'k-');      
    plot(GQNT.scnrarr,GWFM.GQKSA(L-1,:,2),'g-'); plot(impPROJdgn.tro*T(1,:)/impPROJdgn.projlen,impPROJdgn.kmax*KSA(L-1,:,2),'k-');  
    plot(GQNT.scnrarr,GWFM.GQKSA(L-1,:,3),'r-'); plot(impPROJdgn.tro*T(1,:)/impPROJdgn.projlen,impPROJdgn.kmax*KSA(L-1,:,3),'k-');
    title(['Ksamp Traj',num2str(L-1)]);
    xlabel('Time (ms)','fontsize',10,'fontweight','bold');
    ylabel('k-Space (1/m)','fontsize',10,'fontweight','bold');    
end

%----------------------------------------------------
% Define Trajectory Sampling
%----------------------------------------------------
Status('busy','Define Trajectory Sampling');
func = str2func([PROJimp.tsmpfunc,'_Func']);
INPUT.PROJdgn = impPROJdgn;
INPUT.PROJdgn.tro = PROJimp.tro;        % CATPI related
INPUT.PROJimp = PROJimp;
INPUT.GWFM = GWFM;
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
INPUT.testing = testing;
INPUT.GQNT = GQNT;
INPUT.GWFM = GWFM;
INPUT.PSMP = PSMP;
INPUT.TSMP = TSMP;
INPUT.PROJimp = PROJimp;
INPUT.PROJdgn = impPROJdgn;
INPUT.G = G;
INPUT.KSA = KSA;
[KSMP,err] = func(KSMP,INPUT);
if err.flag
    return
end
clear INPUT
samp = KSMP.samp;
Kmat0 = KSMP.Kmat;
Kend = KSMP.Kend;
PROJimp.meanrelkmax = KSMP.meanrelkmax;
PROJimp.maxrelkmax = KSMP.maxrelkmax;

%----------------------------------------------------
% Rotate back
%----------------------------------------------------
Kmat = zeros(size(Kmat0));
thx = -(pi*PROJimp.hippoangle/180);
Rx=[1 0 0;
    0 cos(thx) -sin(thx);
    0 sin(thx) cos(thx)];
sz = size(Kmat0);
for n = 1:sz(1)
    Kmat(n,:,:) = squeeze(Kmat0(n,:,:))*Rx;
end
PROJimp.voxelrotate = 'No'; 

figure(3002); hold on; 
plot(samp,Kmat(L-1,:,1),'b-');   
plot(samp,Kmat(L-1,:,2),'g-');      
plot(samp,Kmat(L-1,:,3),'r-');      
title(['Ksamp Traj (Rot Back)',num2str(L-1)]);
xlabel('Time (ms)','fontsize',10,'fontweight','bold');
ylabel('k-Space (1/m)','fontsize',10,'fontweight','bold');   

%--------------------------------------------
% Output Structure
%--------------------------------------------
GWFM = rmfield(GWFM,{'G' 'GQKSA' 'qTscnr'});
KSMP = rmfield(KSMP,{'samp' 'Kmat' 'Kend'});
IMP.PROJimp = PROJimp;
IMP.PROJdgn = PROJdgn;
IMP.impPROJdgn = impPROJdgn;
IMP.SYS = SYS;
IMP.GQNT = GQNT;
IMP.PSMP = PSMP;
IMP.GWFM = GWFM;
IMP.TSMP = TSMP;
IMP.KSMP = KSMP;
IMP.samp = samp;
IMP.Kmat = Kmat;
IMP.Kend = Kend;
IMP.G = G;


Status('done','');
Status2('done','',2);
Status2('done','',3);


