%=====================================================
% 
%=====================================================

function [GRD,err] = CreateTPITestVSL_v1a_Func(GRD,INPUT)

Status('busy','Create Trajectory Test VSL');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
WRTP = INPUT.WRTP;
WRTG = INPUT.WRTG;
PROJIMP = INPUT.PROJIMP;
clear INPUT

%---------------------------------------------
% Common Variables
%---------------------------------------------
pregdur0 = GRD.pregdur0;
usetrajnum = GRD.usetrajnum;
usetrajdir = GRD.usetrajdir;
idivno = PROJIMP.GQNT.idivno;
twdivno = PROJIMP.GQNT.twdivno;
iseg = PROJIMP.GQNT.iseg;
twseg = PROJIMP.GQNT.twseg;
tgwfm = PROJIMP.GWFM.tgwfm;
twwords = PROJIMP.GQNT.twwords+1;
samp = PROJIMP.samp;
gamma = PROJIMP.PROJimp.gamma;
%PROJimp = PROJIMP.PROJimp;

%---------------------------------------------
% Get Gradient (Kmat to save)
%---------------------------------------------
if strcmp(usetrajdir,'X')
    G0 = PROJIMP.G(usetrajnum,:,1);
    Kmat = PROJIMP.Kmat(usetrajnum,:,1);
    TSRI = PROJIMP.KSMP.TGSR;
    GSRI = PROJIMP.KSMP.GSR(usetrajnum,:,1);    
elseif strcmp(usetrajdir,'Y')
    G0 = PROJIMP.G(usetrajnum,:,2);
    Kmat = PROJIMP.Kmat(usetrajnum,:,2);
    TSRI = PROJIMP.KSMP.TGSR;
    GSRI = PROJIMP.KSMP.GSR(usetrajnum,:,2);        
elseif strcmp(usetrajdir,'Z')
    G0 = PROJIMP.G(usetrajnum,:,3);
    Kmat = PROJIMP.Kmat(usetrajnum,:,3); 
    TSRI = PROJIMP.KSMP.TGSR;
    GSRI = PROJIMP.KSMP.GSR(usetrajnum,:,3);      
end

%---------------------------------------------
% Add PreGDur
%---------------------------------------------
addedsegs = ceil(pregdur0/iseg);
pregdur = addedsegs*iseg;
graddur = tgwfm+pregdur;
G0 = [0 G0];

%---------------------------------------------
% Build Gradient
%---------------------------------------------
G = cat(3,G0,G0,G0);
T = [(0:iseg:iseg*(addedsegs+1)) iseg*(addedsegs+1)+(twseg:twseg:twseg*(twwords-1))];

%---------------------------------------------
% Visualize
%---------------------------------------------
Gvis0 = []; L = [];
for n = 1:length(T)-1
    L = [L [T(n) T(n+1)]];
    Gvis0 = [Gvis0 [G0(n) G0(n)]];
end
L = [L T(length(T))];
Gvis = [Gvis0 G0(length(G0(1,:)))];
figure(1); hold on; 
plot(L,Gvis); 
plot([0 L(length(L))],[0 0],':');    

%---------------------------------------------
% Write to Structure
%---------------------------------------------
GRD.gamma = gamma;
GRD.samp = samp + pregdur;
GRD.Kmat = Kmat;
GRD.pregdur = pregdur;
GRD.pregdur = pregdur;
GRD.addedsegs = addedsegs;
GRD.graddur = graddur;
GRD.G = G0;
GRD.T = T;
GRD.L = L;
GRD.Gvis = Gvis;
GRD.TSRI = TSRI + pregdur;
GRD.GSRI = GSRI;

%---------------------------------------------
% Write Gradients
%---------------------------------------------
func = str2func([GRD.wrtgradfunc,'_Func']);
INPUT.G = G;
INPUT.rdur = [idivno*ones(1,(addedsegs+1)) twdivno*ones(1,twwords)];
INPUT.sym = 'None';
[WRTG,err] = func(WRTG,INPUT);
if err.flag
    return
end
clear INPUT

%---------------------------------------------
% Write Parameter File
%--------------------------------------------- 
func = str2func([GRD.wrtparamfunc,'_Func']);
INPUT.gontime = GRD.graddur;
INPUT.gval = max(G0);
INPUT.gvalinparam = 0;
INPUT.slewrate = 0;
INPUT.falltime = 0;
INPUT.pnum = 1;
INPUT.GradLoc = WRTG.GradLoc;
[WRTP,err] = func(WRTP,INPUT);
if err.flag 
    return
end
clear INPUT

%---------------------------------------------
% Return
%--------------------------------------------- 
GRD.WRTG = WRTG;
GRD.WRTP = WRTP;


