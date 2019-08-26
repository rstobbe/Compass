%=====================================================
% 
%=====================================================

function [GECC,err] = LocalECCFile_v1b_Func(GECC,INPUT)

Status('busy','Local Eddy-Current Compensation');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
GRD = INPUT.GRD;
LECC = INPUT.LECC;
WRTP = INPUT.WRTP;
WRTG = INPUT.WRTG;
ATR = INPUT.ATR;
clear INPUT

%---------------------------------------------
% Common Variables
%---------------------------------------------
gstepdur = GRD.gstepdur/1000;
L = GRD.L;
Gvis = GRD.Gvis;
G = GRD.G;
T = GRD.T;
if isfield(GRD,'initfinaldecay')
    initfinaldecay = GRD.initfinaldecay;
else
    initfinaldecay = 10.8475;                   % just for BPGradUSL1 (old)
end

%---------------------------------------------
% G = same in each dimesion
%---------------------------------------------
G = squeeze(G(:,1));

%---------------------------------------------
% Get Eddy Currents
%---------------------------------------------
tc = LECC.tc;
mag = LECC.mag;

%-----------------------------------------------------
% Compensate
%-----------------------------------------------------
Status2('busy','Compensate',2);
func = str2func([GECC.atrfunc,'_Func']);
INPUT.G = G;
INPUT.gstepdur = gstepdur;
INPUT.tc = tc;
INPUT.mag = -mag;
[ATR,err] = func(ATR,INPUT);
if err.flag
    return
end
t = ATR.t;
eddy0 = ATR.eddy0;
eddy = ATR.eddy;
Geddy = ATR.Geddy;
Gcomp0 = ATR.Geddyadd;
Tecc = ATR.Teddy;

%---------------------------------------------
% Make 3 dimensions
%---------------------------------------------
Gcomp = zeros(1,length(Gcomp0),3);
Gcomp(1,:,1) = Gcomp0;
Gcomp(1,:,2) = Gcomp0;
Gcomp(1,:,3) = Gcomp0;

%---------------------------------------------
% Plot 
%---------------------------------------------
figure(10); hold on;
plot(t,-squeeze(eddy0(:,:))*100);
plot(t,-eddy*100,'k','linewidth',2);
title('Eddy Current from Regression');
xlabel('(ms)'); ylabel('Gradient (%)'); 

%---------------------------------------------
% Visualize
%---------------------------------------------
for dim = 1:3
    Gvis0 = []; LECCvis = [];
    for n = 1:length(Tecc)-1
        LECCvis = [LECCvis [Tecc(n) Tecc(n+1)]];
        Gvis0 = [Gvis0 [Gcomp(1,n,dim) Gcomp(1,n,dim)]];
    end
    LECCvis = [LECCvis Tecc(length(Tecc))];
    GECCvis(1,:,dim) = [Gvis0 Gcomp(1,length(Gcomp(1,:,dim)),dim)];
end
figure(11); hold on;
plot(L,Gvis,'k');
plot(Tecc,-Geddy,'r-');
plot(LECCvis,GECCvis(1,:,1),'b-'); 
title('Added Transient Field (red) plus Original (black) yeilds Projected Field (blue)');
xlabel('(ms)'); ylabel('Gradient (mT/m)'); 

%---------------------------------------------
% Test
%---------------------------------------------
relovershoot = squeeze(max(Gcomp(1,:,:))/max(G(:)));
ind = find(Tecc >= initfinaldecay,1,'first');
appgsl = 1000*squeeze((Gcomp(1,ind+5,:)-Gcomp(1,ind,:))/(5*gstepdur));

%---------------------------------------------
% Write to Structure
%---------------------------------------------
GECC.GRD = GRD;
GECC.relovershoot = relovershoot;
GECC.appgsl = appgsl;
GECC.maxgsl = [];
GECC.graddur = gstepdur*length(Gcomp);
GECC.G = Gcomp;
GECC.T = Tecc;
GECC.L = L;
GECC.Gvis = Gvis;
GECC.gmax = max(abs(Gcomp(:)));
    
%---------------------------------------------
% Test
%---------------------------------------------
test = GECC.T(length(GECC.T)) + gstepdur;
if round(GECC.graddur*1e9) ~= round(test*1e9)
    error();
end

%---------------------------------------------
% Write Gradients
%---------------------------------------------
func = str2func([GECC.wrtgradfunc,'_Func']);
INPUT.G = GECC.G;
INPUT.rdur = ones(1,length(GECC.G(1,:,1)));
INPUT.sym = 'None';
[WRTG,err] = func(WRTG,INPUT);
if err.flag
    return
end
clear INPUT

%---------------------------------------------
% Write Parameter File
%--------------------------------------------- 
func = str2func([GECC.wrtparamfunc,'_Func']);
INPUT.gontime = GECC.graddur;
INPUT.gval = GECC.gmax;
INPUT.gvalinparam = 0;
INPUT.slewrate = max(GECC.appgsl);
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
GECC.WRTG = WRTG;
GECC.WRTP = WRTP;


