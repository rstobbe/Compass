%===========================================
% 
%===========================================

function [PSDS,err] = PSDBuild_TPIdesreload_v1a_Func(PSDS,INPUT)

Status2('busy','Create PSD Function',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
Vis = 'On';

%---------------------------------------------
% Load Input
%---------------------------------------------
DES = PSDS.DES;
GAM = DES.TPIT.GAM;
PROJdgn = DES.PROJdgn;
diam = INPUT.tfdiam;
orient = INPUT.tforient;
clear INPUT

%---------------------------------------------
% Tests
%---------------------------------------------
if isempty(diam)
    diam = PROJdgn.rad*2;
end
if isempty(orient)
    % use IMP orient here
end

%---------------------------------------------
% Variables / Structures
%---------------------------------------------
elip = PROJdgn.elip;
projlen = PROJdgn.TPIprojlen;
tro = PROJdgn.tro;
p = PROJdgn.p;

R = diam/2;
Ksz = 2*ceil(R)+1;   
C = (Ksz+1)/2;
psd = zeros(Ksz,Ksz,Ksz);
Tot = 0;

Const = ((R^3)*projlen)/(tro*(GAM.GamShape(1)^2));
Status2('busy','Workers in Parallel...',3);  
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
            if r == 0
                psd(x,y,z) = 0;
                Tot = Tot + 1;
            elseif r <= p
                gam = interp1(GAM.r,GAM.GamShape,r);
                psd(x,y,z) = Const*(r^2)*(gam^2);   
                Tot = Tot + 1;
            elseif (r > p) && (r < 1)                    
                gam = interp1(GAM.r,GAM.GamShape,r);
                psd(x,y,z) = Const*gam;  
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

%---------------------------------------------
% Orientation
%---------------------------------------------
if strcmp(orient,'Sagittal')
    psd = permute(psd,[3 2 1]);
elseif strcmp(orient,'Coronal')
    psd = permute(psd,[1 3 2]);
end

%---------------------------------------------
% Calculate Relative SNR
%---------------------------------------------
rsnr = 1000./sqrt(sum(psd(:))) * (PROJdgn.fov/200)^3;
rsnr = rsnr*sqrt(3000/PROJdgn.nproj);                          % test

%---------------------------------------------
% Display / Return
%---------------------------------------------
if strcmp(Vis,'On')
    figure(200); hold on;
    PSDprof = squeeze(psd(:,(length(psd)+1)/2,(length(psd)+1)/2)); plot(PSDprof,'r'); 
    PSDprof = squeeze(psd((length(psd)+1)/2,(length(psd)+1)/2,:)); plot(PSDprof,'r:'); 
    title('PSD Function'); xlabel('Matrix Diameter'); ylabel('Arb');
    ylim([0 max(PSDprof(:))*1.1]); xlim([1 length(PSDprof)]);    
end

%---------------------------------------------
% Panel
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'Method',PSDS.method,'Output'};
Panel(3,:) = {'rSNR (Arb)',round(rsnr*(34/5.87)*10)/10,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);   

PSDS.rsnr = rsnr;
PSDS.psd = psd;
PSDS.kmatvol = elip*diam^3;
PSDS.psddiam = diam;
PSDS.Panel = Panel;
PSDS.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);
