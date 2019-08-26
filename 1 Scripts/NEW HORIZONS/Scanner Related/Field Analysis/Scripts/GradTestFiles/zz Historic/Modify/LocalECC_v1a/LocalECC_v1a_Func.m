%=====================================================
% 
%=====================================================

function [GECC,err] = LocalECC_v1a_Func(GECC,INPUT)

Status('busy','Local Eddy-Current Compensation');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
GRD = INPUT.GRD;
WRTP = INPUT.WRTP;
WRTG = INPUT.WRTG;
clear INPUT

%---------------------------------------------
% Common Variables
%---------------------------------------------
gstepdur = GRD.gstepdur;
G = GRD.G;
T = GRD.T;

%---------------------------------------------
% Consolodate Compensation
%---------------------------------------------
tc(1:length(GECC.xtc),1) = GECC.xtc;
tc(1:length(GECC.ytc),2) = GECC.ytc;
tc(1:length(GECC.ztc),3) = GECC.ztc;
mag(1:length(GECC.xmag),1) = GECC.xmag;
mag(1:length(GECC.ymag),2) = GECC.ymag;
mag(1:length(GECC.zmag),3) = GECC.zmag;

%---------------------------------------------
% Compensation
%---------------------------------------------
eccdur = 5*max(tc(:));
t = (0:gstepdur:eccdur);
ecclen = length(t);
[N,M] = size(tc);
ecc0 = zeros(N,ecclen,M);
for m = 1:M
    for n = 1:N
        if tc(n,m) == 0
            if mag(n,m) ~= 0
                err.flag = 1;
                err.msg = 'can not have zero time constant';
                return
            end   
            tc(n,m) = 1;
        end
        ecc0(n,:,m) = 0.01*mag(n,m)*exp(-t/tc(n,m));
    end
end
ecc = squeeze(sum(ecc0,1));

%---------------------------------------------
% Plot Eddy Currents
%---------------------------------------------
figure(1); hold on;
plot(t,squeeze(ecc0(:,:,1)));
plot(t,ecc(:,1),'k','linewidth',2);
title('x-ecc');
figure(2); hold on;
plot(t,squeeze(ecc0(:,:,2)));
plot(t,ecc(:,2),'k','linewidth',2);
title('y-ecc');
figure(3); hold on;
plot(t,squeeze(ecc0(:,:,3)));
plot(t,ecc(:,3),'k','linewidth',2);
title('z-ecc');

%---------------------------------------------
% Compensate
%---------------------------------------------
[ngrads,gradlen] = size(G);
Gecc = zeros(ngrads,gradlen+ecclen,3);
Tecc = (0:gstepdur:(gradlen+ecclen-1)*gstepdur)/1000;
for dim = 1:3
    for m = 1:ngrads
        Gecc(m,1:ecclen,dim) = G(m,1)*ecc(:,dim);
        for n = 2:gradlen
            %test = (G(m,n)-G(m,n-1))
            Gecc(m,n:n+ecclen-1,dim) = Gecc(m,n:n+ecclen-1,dim) + (G(m,n)-G(m,n-1))*permute(ecc(:,dim),[2 1]);
        end
    end
end
Gcomp = [cat(3,G,G,G) zeros(ngrads,ecclen,3)]+Gecc;

%---------------------------------------------
% Plot Compensated Waveforms
%---------------------------------------------
figure(11); hold on;
plot(T,G(1,:),'b-');
plot(Tecc,-Gecc(1,:,1),'r-');
plot(Tecc,[G(1,:) zeros(1,ecclen)]-Gecc(1,:,1),'k-','linewidth',2);
title('x-Gecc');
figure(12); hold on;
plot(T,G(1,:),'b-');
plot(Tecc,-Gecc(1,:,2),'r-');
plot(Tecc,[G(1,:) zeros(1,ecclen)]-Gecc(1,:,2),'k-','linewidth',2);
title('y-Gecc');
figure(13); hold on;
plot(T,G(1,:),'b-');
plot(Tecc,-Gecc(1,:,3),'r-');
plot(Tecc,[G(1,:) zeros(1,ecclen)]-Gecc(1,:,3),'k-','linewidth',2);
title('z-Gecc');

%---------------------------------------------
% Visualize
%---------------------------------------------
for dim = 1:3
    for m = 1:ngrads
        Gvis0 = []; L = [];
        for n = 1:length(T)-1
            L = [L [T(n) T(n+1)]];
            Gvis0 = [Gvis0 [Gcomp(m,n,dim) Gcomp(m,n,dim)]];
        end
        L = [L T(length(T))];
        Gvis(m,:,dim) = [Gvis0 Gcomp(m,length(Gcomp(1,:,dim)),dim)];
        figure(20+dim); hold on; 
        plot(L,Gvis(m,:,dim),'k'); 
        plot([0 L(length(L))],[0 0],':');    
    end
end

%---------------------------------------------
% Test
%---------------------------------------------
relovershoot = squeeze(max(Gcomp(1,:,:))/max(G(1,:)));
ind = find(Tecc >= GRD.initfinaldecay,1,'first');
appgsl = 1000*squeeze((Gcomp(1,ind+5,:)-Gcomp(1,ind,:))/(5*gstepdur));

%---------------------------------------------
% Write to Structure
%---------------------------------------------
GECC.GRD = GRD;
GECC.relovershoot = relovershoot;
GECC.appgsl = appgsl;
GECC.G = Gcomp;
GECC.T = Tecc;
GECC.L = L;
GECC.Gvis = Gvis;

%---------------------------------------------
% Write Gradients
%---------------------------------------------
func = str2func([GRD.wrtgradfunc,'_Func']);
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
func = str2func([GRD.wrtparamfunc,'_Func']);
INPUT.gontime = GRD.graddur;
INPUT.gval = GRD.gstop;
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
GRD.WRTG = WRTG;
GRD.WRTP = WRTP;


