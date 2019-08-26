%=========================================================
% Implement Looping Radial Projections
%=========================================================

function [warning,warnflag,ImpDat] = LR_v1d(AIDsys,SYS,AIDimp,AIDipt,AIDgbl,AIDdgn,PROJipt,PROJdgn,IMPipt,T,KSA0,testing)

warnnum = 1;
warnflag = [0,0];
warning = {'',''};

validfor = {'LR1'};

ImpDat = '';
good = 0;
for n = 1:length(validfor)
    if (strcmp(AIDgbl.projdes,validfor{n}))
        good = 1;
        break
    end
end
if good == 0
    warnflag(warnnum) = 2;
    warning{warnnum} = 'Implementation Method Not Appropriate';
    return
end

AIDimp.meth = 'LR_v1d';
IMP = struct();

%----------------------------------------------------
% Input Values
%----------------------------------------------------
AIDimp.name = IMPipt(strcmp('Imp_Name',{IMPipt.labelstr})).entrystr;
orient = IMPipt(strcmp('Orient',{IMPipt.labelstr})).entrystr;
if iscell(orient)
    orient = IMPipt(strcmp('Orient',{IMPipt.labelstr})).entrystr{IMPipt(strcmp('Orient',{IMPipt.labelstr})).entryvalue};
end
AIDimp.gqntmeth = IMPipt(strcmp('Grad_Quant',{IMPipt.labelstr})).entrystr;
AIDimp.wfmmeth = IMPipt(strcmp('Grad_WFM',{IMPipt.labelstr})).entrystr;
AIDimp.tsmpmeth = IMPipt(strcmp('Traj_Samp',{IMPipt.labelstr})).entrystr;
AIDimp.ksmpmeth = IMPipt(strcmp('k_Samp',{IMPipt.labelstr})).entrystr;

%----------------------------------------------------
% Tests
%----------------------------------------------------
% check for supported sub-routines...

%----------------------------------------------------
% Build Quantization Vector
%----------------------------------------------------
Status('busy','Build Quantization Vector');
global GQNTLOC 
addpath(genpath(GQNTLOC)); rmpath(genpath(GQNTLOC)); addpath([GQNTLOC,AIDimp.gqntmeth]);
quantfunc = (str2func(AIDimp.gqntmeth));
[warning{warnnum},warnflag(warnnum),AIDgqnt,GQNT,IMPipt] = quantfunc(AIDdgn,IMPipt);
if warnflag(warnnum) == 2
    return
elseif warnflag(warnnum) ~= 0
    warnnum = warnnum + 1;
end

%----------------------------------------------------
% Sampling Parameters
%----------------------------------------------------
Status('busy','Sample Trajectory');
global TSAMPLOC
addpath(genpath(TSAMPLOC)); rmpath(genpath(TSAMPLOC)); addpath([TSAMPLOC,AIDimp.tsmpmeth]);
sampfunc = (str2func(AIDimp.tsmpmeth));
[warning{warnnum},warnflag(warnnum),AIDsamp,SAMP,IMPipt] = sampfunc(AIDdgn,IMPipt);
if warnflag(warnnum) == 2
    return
elseif warnflag(warnnum) ~= 0
    warnnum = warnnum + 1;
end

%----------------------------------------------------
% Update AIDrp
%----------------------------------------------------
AIDrp = AIDdgn;
AIDrp.npro = AIDsamp.npro;
AIDrp.dwell = AIDsamp.dwell;
AIDrp.sampstart = AIDsamp.sampstart;
AIDrp.tro = AIDsamp.tro;
AIDrp.osamp = AIDsamp.osamp;
AIDrp.projosamp = AIDdgn.projosamp;    

%----------------------------------------------------
% Generate Projections
%----------------------------------------------------
if testing == 0 || testing == 2;
    Status('busy','Generate Trajectory');
    op = 1;
    func = str2func(AIDgbl.projdes);   
    [~,~,PROJrp,~,~,~,T,KSA0] = func(AIDipt,PROJipt,PROJdgn,IMP,op);
else
    PROJrp = PROJdgn;
end

%----------------------------------------------------
% Orient
%----------------------------------------------------
KSA = zeros(size(KSA0));
if strcmp(orient,'Axial');          % z - SI 
    KSA = KSA0;
elseif strcmp(orient,'Coronal');    % z - AP 
    KSA(:,:,1) = KSA0(:,:,1);
    KSA(:,:,2) = KSA0(:,:,3);
    KSA(:,:,3) = KSA0(:,:,2);
elseif strcmp(orient,'Sagittal');   % z - LR
    KSA(:,:,1) = KSA0(:,:,3);
    KSA(:,:,2) = KSA0(:,:,2);
    KSA(:,:,3) = KSA0(:,:,1);
end
clear KSA0;

%----------------------------------------------------
% Create Gradient Waveform
%----------------------------------------------------
Status('busy','Create Gradient Waveform');
global GWFMLOC
addpath(genpath(GWFMLOC)); rmpath(genpath(GWFMLOC)); addpath([GWFMLOC,AIDimp.wfmmeth]); addpath(genpath([GWFMLOC,'zz Common Routines']));
func = str2func(AIDimp.wfmmeth);
[warning{warnnum},warnflag(warnnum),G,AIDgqnt,GQNT,GQKSA,AIDwfm,WFM,IMPipt] = func(AIDsys,AIDrp,AIDgqnt,GQNT,T,KSA,AIDimp,IMPipt);
if warnflag(warnnum) == 2
    return
elseif warnflag(warnnum) ~= 0
    warnnum = warnnum + 1;
end
if strcmp(AIDimp.visuals,'On1') || strcmp(AIDimp.visuals,'On2') || strcmp(AIDimp.visuals,'On3')
    Gvis = []; L = [];
    for n = 1:length(GQNT.arrfull)-1
        L = [L [GQNT.arrfull(n) GQNT.arrfull(n+1)]];
        Gvis = [Gvis [G(:,n,:) G(:,n,:)]];
    end
    figure(1000); hold on; plot(L,Gvis(1,:,1),'b-'); plot(L,Gvis(1,:,2),'g-'); plot(L,Gvis(1,:,3),'r-'); xlim([0 max(L)]); title('Grads Traj1');
end

%----------------------------------------------------
% Calculate Split
%----------------------------------------------------
if strcmp(AIDgqnt.sym,'PosNeg');
    nprojmult = 2;
else
    nprojmult = 1;
end
tw = AIDgqnt.tw+10;
split0 = ceil(tw/(64000-9));
split = split0;
go = 1;
while go == 1
    if rem(AIDdgn.nproj/nprojmult,split) == 0
        break
    end    
    split = split + 1;
end
if split > 2*split0
    warnflag(warnnum) = 2;
    warning{warnnum} = ['Projection number error.  Try ',num2str(nprojmult*split0*round((AIDdgn.nproj/nprojmult)/split0)),' projections'];
    return
end
if split > split0
    warnflag(warnnum) = 1;
    warning{warnnum} = ['Split can be reduced. Try ',num2str(nprojmult*split0*round((AIDdgn.nproj/nprojmult)/split0)),' projections'];
    warnnum = warnnum + 1;
end
SYS.split = split;

%----------------------------------------------------
% System and Proj-Mult
%----------------------------------------------------
projpersplit = (AIDdgn.nproj/nprojmult)/split;
go = 1;
n = 1;
while go == 1
    if rem(projpersplit,n) == 0 
        if projpersplit/n <= 670
            SYS.projmult = projpersplit/n;
            break
        end
    end
    n = n+1;
    if n > 20
        warnflag(warnnum) = 2;
        warning{warnnum} = 'Projection Number Error - Try Different Number of Projections';
        return
    end
end

%----------------------------------------------------
% Update panel
%---------------------------------------------------
n = length(IMPipt)+1;
IMPipt(n).number = n;
IMPipt(n).labelstyle = '0output';
IMPipt(n).labelstr = 'Split';
IMPipt(n).entrystyle = '0text';
IMPipt(n).entrystr = num2str(SYS.split);
IMPipt(n).unitstyle = '0units';
IMPipt(n).unitstr = '';

n = n+1;
IMPipt(n).number = n;
IMPipt(n).labelstyle = '0output';
IMPipt(n).labelstr = 'ProjMult';
IMPipt(n).entrystyle = '0text';
IMPipt(n).entrystr = num2str(SYS.projmult);
IMPipt(n).unitstyle = '0units';
IMPipt(n).unitstr = '';

%---------------------------------------
% Resample k-Space
%---------------------------------------
Status('busy','Resample k-Space');
global KSMPLOC
addpath(genpath(KSMPLOC)); rmpath(genpath(KSMPLOC)); addpath([KSMPLOC,AIDimp.ksmpmeth]); addpath(genpath([KSMPLOC,'zz Common Routines']));
func = str2func(AIDimp.ksmpmeth);
[warning{warnnum},warnflag(warnnum),samp,Kmat,Kend,AIDksmp,KSMP,IMPipt] = func(AIDrp,GQNT,G,AIDimp,IMPipt);
if warnflag(warnnum) == 2
    return
elseif warnflag(warnnum) ~= 0
    warnnum = warnnum + 1;
end

%----------------------------------------------------
% Update AIDipars
%---------------------------------------------------
AIDipars.name = AIDgbl.Folder;
AIDipars.impmeth = AIDimp.meth;
AIDipars.impname = AIDimp.name;
AIDipars.sysname = AIDsys.name;
AIDipars.vox = 500/AIDrp.kmax;
AIDipars.fov = 1000/AIDrp.kstep;
AIDipars.nproj = AIDrp.nproj;
AIDipars.tro = AIDsamp.tro;
AIDipars.npro = AIDsamp.npro;
AIDipars.sampstart = AIDsamp.sampstart;
AIDipars.dwell = AIDsamp.dwell;
AIDipars.filBW = AIDsamp.filBW;
AIDipars.gro = AIDgqnt.gro;
AIDipars.gmax = AIDwfm.gmax;
AIDipars.mingres = GQNT.gres;
AIDipars.sym = GQNT.sym;
AIDipars.split = SYS.split;
AIDipars.projmult = SYS.projmult;
AIDipars.maxgrad = AIDsys.maxgrad;
AIDipars.gamma = AIDimp.gamma;

%----------------------------------------------------
% Build Return Structure
%----------------------------------------------------
ImpDat.IMPipt = IMPipt;
ImpDat.AIDgbl = AIDgbl;
ImpDat.AIDrp = AIDrp;
ImpDat.AIDipars = AIDipars;
ImpDat.AIDimp = AIDimp;
ImpDat.IMP = IMP;
ImpDat.AIDsamp = AIDsamp;
ImpDat.SAMP = SAMP;
ImpDat.AIDgqnt = AIDgqnt;
ImpDat.GQNT = GQNT;
ImpDat.AIDwfm = AIDwfm;
ImpDat.WFM = WFM;
ImpDat.AIDksmp = AIDksmp;
ImpDat.KSMP = KSMP;
ImpDat.AIDsys = AIDsys;
ImpDat.SYS = SYS;
ImpDat.PROJrp = PROJrp;
ImpDat.PROJdgn = PROJdgn;
ImpDat.G = G;
ImpDat.Kmat = Kmat;
ImpDat.Kend = Kend;  

%if strcmp(IMP.rtrnanalysis,'Yes')
%    ImpDat.IMP.T = T;
%    ImpDat.IMP.KSA = KSA;
%end

%---------------------------------------
% Visuals
%---------------------------------------
if strcmp(AIDimp.visuals,'On1') || strcmp(AIDimp.visuals,'On2') || strcmp(AIDimp.visuals,'On3')
    figure(2000); hold on; 
    plot(samp,Kmat(1,:,1),'r*'); plot(GQNT.arr,GQKSA(1,:,1),'b-'); plot(AIDrp.tro*T(1,:),AIDrp.kmax*KSA(1,:,1),'k-'); title('Ksamp Traj1');      
    plot(samp,Kmat(1,:,2),'r*'); plot(GQNT.arr,GQKSA(1,:,2),'b-'); plot(AIDrp.tro*T(1,:),AIDrp.kmax*KSA(1,:,2),'k-');  
    plot(samp,Kmat(1,:,3),'r*'); plot(GQNT.arr,GQKSA(1,:,3),'b-'); plot(AIDrp.tro*T(1,:),AIDrp.kmax*KSA(1,:,3),'k-'); 
end

