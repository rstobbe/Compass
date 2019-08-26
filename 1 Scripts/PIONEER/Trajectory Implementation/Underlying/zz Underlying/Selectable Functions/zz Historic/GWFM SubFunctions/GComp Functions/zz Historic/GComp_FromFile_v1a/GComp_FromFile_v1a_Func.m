%=====================================================
% 
%=====================================================

function [GECC,err] = GECC_FromFile_v1a_Func(GECC,INPUT)

Status2('busy','Local Eddy-Current Compensation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
G = INPUT.G0;
T = INPUT.qT;
LECC = GECC.LECC;
clear INPUT

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
% Common
%---------------------------------------------
tc = LECC.tc;
mag = LECC.mag;
gstepdur = T(2);        % gstepdur must be constant along gradient

%---------------------------------------------
% Compensation
%---------------------------------------------
eccdur = 12*max(tc(:));
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
plot(t,squeeze(ecc0(:,:))*100);
plot(t,ecc*100,'k','linewidth',2);
title('ECC'); xlabel('(ms)'); ylabel('compensation (%)');

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
Tecc = (0:gstepdur:(gradlen+ecclen)*gstepdur);
for dim = 1:3
    for m = 1:ngrads
        Gecc(m,1:ecclen,dim) = G(m,1,dim)*ecc(:,dim);
        for n = 2:gradlen
            %test = (G(m,n)-G(m,n-1))
            Gecc(m,n:n+ecclen-1,dim) = Gecc(m,n:n+ecclen-1,dim) + (G(m,n,dim)-G(m,n-1,dim))*permute(ecc(:,dim),[2 1]);
        end
    end
end
Gcomp = cat(2,G,zeros(ngrads,ecclen,3))+Gecc;

%---------------------------------------------
% Plot Compensation
%---------------------------------------------
figure(22); hold on;
plot(Tecc(1:length(Tecc)-1),-Gecc(1,:,1),'r-');
title('Gradient Compensation'); xlabel('(ms)'); ylabel('mT');

%---------------------------------------------
% Return
%---------------------------------------------
GECC.graddel = LECC.graddel;
GECC.gcoil = LECC.gcoil;
GECC.Tecc = Tecc;
GECC.Gecc = Gecc;
GECC.Gcomp = Gcomp;

Status2('done','',2);
Status2('done','',3);
