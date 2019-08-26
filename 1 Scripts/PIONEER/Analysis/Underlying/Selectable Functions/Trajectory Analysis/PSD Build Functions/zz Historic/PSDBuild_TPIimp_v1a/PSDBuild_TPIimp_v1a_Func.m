%===========================================
% 
%===========================================

function [PSDS,err] = PSDBuild_TPIimp_v1a_Func(PSDS,INPUT)

Status2('busy','Create PSD Function',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
Vis = 'On';

%---------------------------------------------
% Load Input
%---------------------------------------------
PROJdgn = INPUT.IMP.PROJdgn;
PROJimp = INPUT.IMP.PROJimp;
IMP = INPUT.IMP;
diam = INPUT.tfdiam;
clear INPUT

if isempty(diam)
    diam = PROJdgn.rad*2;
end

%---------------------------------------------
% Create PSD Shape
%---------------------------------------------
SDCS = PSDS.SDCS;
InitSampDens = (SDCS.W)./(SDCS.SDC);
PostAcqWeight = SDCS.SDC;
psd = InitSampDens.*(PostAcqWeight.^2);
[psdmat] = SDCArr2Mat(psd,PROJimp.nproj,PROJimp.npro);
psdarr = mean(psdmat,1);

Kmat = IMP.Kmat;
r = sqrt(Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2);
r = mean(r,1);
r = r/max(r);

%figure(100); hold on;
%plot(r,psdarr/sum(psdarr));
%plot(r,psdmat(50:50:3000,:)/sum(psdarr));
%plot(PROJdgn.r,PROJdgn.PSD/sum(PROJdgn.PSD));

%---------------------------------------------
% Variables / Structures
%---------------------------------------------
PSDS.r = [0 r];
PSDS.psdarr = [0 psdarr];
%PSDS.r = PROJdgn.r;
%PSDS.psdarr = PROJdgn.PSD;
elip = PROJdgn.elip;

R = diam/2;
Ksz = 2*ceil(R)+1;   
C = (Ksz+1)/2;
psd = zeros(Ksz,Ksz,Ksz);
Tot = 0;

%Status2('busy','Workers in Parallel...',3);  
parfor x = 1:Ksz
    for y = 1:Ksz
        for z = 1:Ksz
            r0 = sqrt((x-C)^2 + (y-C)^2 + (z-C)^2);
            if r0 == 0
                r = 0;
            else
                phi = acos((z-C)/r0);
                rmax = sqrt(((elip*R)^2)/(elip^2*(sin(phi))^2 + (cos(phi))^2));
                r = r0/rmax;
            end
            if r <= 1
                psd(x,y,z) = interp1(PSDS.r,PSDS.psdarr,r);
                Tot = Tot + 1;
            end
        end
    end
end

compV = elip*pi*(4/3)*R.^3;
Dif = compV/Tot;
if abs((1-Dif)*100) > 2
    err.flag = 1;
    err.msg = 'Spheroid Creation More than 2% in error (increase matrix dimension)';
    return
end

psd = psd/sum(psd(:));                      % display purposes

if strcmp(Vis,'On')
    figure(200); hold on;
    PSDprof = squeeze(psd(:,(length(psd)+1)/2,(length(psd)+1)/2)); plot(PSDprof,'r'); 
    PSDprof = squeeze(psd((length(psd)+1)/2,(length(psd)+1)/2,:)); plot(PSDprof,'r:'); 
    title('PSD Function'); xlabel('Matrix Diameter'); ylabel('Arb');
    ylim([0 max(PSDprof(:))*1.1]); xlim([1 length(PSDprof)]);    
end

PSDS.psd = psd;
PSDS.kmatvol = elip*diam^3;
PSDS.psddiam = diam;

Status2('done','',2);
Status2('done','',3);
