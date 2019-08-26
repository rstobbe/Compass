%=========================================================
% 
%=========================================================

function [IMP,err] = TPI_INOVA_v1f_Func(INPUT)

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
% Solve Gradient Quantization Vector
%----------------------------------------------------
Status('busy','Solve Gradient Quantization Vector');
func = str2func([PROJimp.qvecslvfunc,'_Func']);
INPUT.PROJdgn = PROJdgn;
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
% Determine System Implementation Aspects
%----------------------------------------------------
Status('busy','Determine System Implementation Aspects');
func = str2func([PROJimp.sysimpfunc,'_Func']);
INPUT.PROJdgn = PROJdgn;
INPUT.twwords = GQNT0.twwords;
[SYS,err] = func(SYS,INPUT);
if err.flag
    return
end
clear INPUT

%----------------------------------------------------
% Recalculate 'p' and 'projlen' for new 'tro' and 'iseg'
%----------------------------------------------------
Status('busy','Determine Effect of Design Tweak');
func = str2func([PROJdgn.method,'_Func']);
impPROJdgn = PROJdgn;
impPROJdgn.tro = PROJimp.tro;
impPROJdgn.iseg = PROJimp.iseg;
INPUT.PROJdgn = impPROJdgn;
INPUT.GAMFUNC = GAMFUNC;
[DES,err] = func(INPUT);
if err.flag ~= 0
    return
end
impPROJdgn = DES.PROJdgn;
PROJimp.p = impPROJdgn.p;
clear INPUT
clear DES

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
Kmat = KSMP.Kmat;
Kend = KSMP.Kend;
PROJimp.meanrelkmax = KSMP.meanrelkmax;
PROJimp.maxrelkmax = KSMP.maxrelkmax;

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


