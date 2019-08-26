%=====================================================
% 
%=====================================================

function [GECC,err] = LocalECCFile_v1a_Func(GECC,INPUT)

Status('busy','Local Eddy-Current Compensation');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
GRD = INPUT.GRD;
ECC = INPUT.ECC;
WRTP = INPUT.WRTP;
WRTG = INPUT.WRTG;
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
    initfinaldecay = 10.8475;
end

%---------------------------------------------
% G must have 3 dimensions
%---------------------------------------------
if ndims(G) < 3
    [N,M] = size(G);
    G0 = zeros(1,N,M);
    G0(1,:,:) = G;
    G = G0;
end

%---------------------------------------------
% Consolodate Compensation
%---------------------------------------------
if isfield(ECC,'tc3')
    tc(1) = ECC.tc1;
    tc(2) = ECC.tc2;
    tc(3) = ECC.tc3;
    mag(1) = ECC.mag1;
    mag(2) = ECC.mag2;
    mag(3) = ECC.mag3;
end

%---------------------------------------------
% Compensation
%---------------------------------------------
eccdur = 5*max(tc(:));
t = (0:gstepdur:eccdur);
ecclen = length(t);
N = length(tc);
ecc0 = zeros(N,ecclen);
for n = 1:N
    if tc(n) == 0
        if mag(n) ~= 0
            err.flag = 1;
            err.msg = 'can not have zero time constant';
            return
        end   
        tc(n) = 1;
    end
    ecc0(n,:) = 0.01*mag(n)*exp(-t/tc(n));
end
ecc = squeeze(sum(ecc0,1));

%---------------------------------------------
% Plot Eddy Currents
%---------------------------------------------
clf(figure(21));
figure(21); hold on;
plot(t,squeeze(ecc0(:,:)));
plot(t,ecc,'k','linewidth',2);

%---------------------------------------------
% Same Ecc on all dimensions
%---------------------------------------------
ecc0 = zeros(length(ecc),3);
ecc0(:,1) = ecc;
ecc0(:,2) = ecc;
ecc0(:,3) = ecc;
ecc = ecc0;

%---------------------------------------------
% Compensate
%---------------------------------------------
[ngrads,gradlen,dim] = size(G);
Gecc = zeros(ngrads,gradlen+ecclen,3);
Tecc = (0:gstepdur:(gradlen+ecclen-1)*gstepdur);
for dim = 1:3
    for m = 1:ngrads
        Gecc(m,1:ecclen,dim) = G(m,1)*ecc(:,dim);
        for n = 2:gradlen
            %test = (G(m,n)-G(m,n-1))
            Gecc(m,n:n+ecclen-1,dim) = Gecc(m,n:n+ecclen-1,dim) + (G(m,n)-G(m,n-1))*permute(ecc(:,dim),[2 1]);
        end
    end
end
Gcomp = cat(2,G,zeros(ngrads,ecclen,3))+Gecc;

%---------------------------------------------
% Plot Compensated Waveforms
%---------------------------------------------
figure(22); hold on;
plot(L,Gvis(1,:,1),'b-');
plot(Tecc,-Gecc(1,:,1),'r-');
plot(Tecc,Gcomp(1,:,1),'k-','linewidth',2);
title('x-Gecc');

%---------------------------------------------
% Visualize
%---------------------------------------------
for dim = 1:3
    for m = 1:ngrads
        Gvis0 = []; L = [];
        for n = 1:length(Tecc)-1
            L = [L [Tecc(n) Tecc(n+1)]];
            Gvis0 = [Gvis0 [Gcomp(m,n,dim) Gcomp(m,n,dim)]];
        end
        L = [L Tecc(length(Tecc))];
        Gvis(m,:,dim) = [Gvis0 Gcomp(m,length(Gcomp(1,:,dim)),dim)];
    end
end
figure(22); hold on;
plot(L,Gvis(1,:,1),'k-'); 

%---------------------------------------------
% Test
%---------------------------------------------
relovershoot = squeeze(max(Gcomp(1,:,:))/max(G(1,:)));
ind = find(Tecc >= initfinaldecay,1,'first');
appgsl = 1000*squeeze((Gcomp(1,ind+5,:)-Gcomp(1,ind,:))/(5*gstepdur));

%---------------------------------------------
% Test for max slew...
%---------------------------------------------


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
INPUT.pnum = ngrads;
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


