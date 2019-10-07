%===========================================
% 
%===========================================

function [PSDS,err] = PSDBuild_TPIimp_v1c_Func(PSDS,INPUT)

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
% Show SDC Results
%---------------------------------------------
Kmat = IMP.Kmat;
r = sqrt(Kmat(:,:,1).^2 + Kmat(:,:,2).^2 + Kmat(:,:,3).^2);
r = mean(r,1);
r = r/max(r);

finaltf = PSDS.SDCS.W;                                                              % be aware of 'convolution scaling' change from 'Iterate_DblConv_v1n' and on
finaltfmat = SDCArr2Mat(finaltf,PROJimp.nproj,PROJimp.npro);
finaltfarr = mean(finaltfmat,1);                                        

postacqweight = PSDS.SDCS.SDC;
initsampdens = finaltf./postacqweight;
        
psd = (1/PROJimp.dwell)*initsampdens.*((postacqweight/finaltfarr(1)).^2);           % include normalization for SNR calc
[psdmat] = SDCArr2Mat(psd,PROJimp.nproj,PROJimp.npro);
psdarr = mean(psdmat,1);

%---------------------------------------------
% Variables / Structures
%---------------------------------------------
PSDS.r = [0 r];
PSDS.psdarr = [0 psdarr];
elip = PROJdgn.elip;

R = diam/2;
Ksz = 2*ceil(R)+1;   
C = (Ksz+1)/2;
psd = zeros(Ksz,Ksz,Ksz);
Tot = 0;

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

%---------------------------------------------
% Orient
%---------------------------------------------
if strcmp(PROJimp.orient,'Coronal')
    psd = permute(psd,[1,3,2]);
elseif strcmp(PROJimp.orient,'Sagittal')
    psd = permute(psd,[2,3,1]);
end

%---------------------------------------------
% Calculate Relative SNR
%---------------------------------------------
rsnr = 1000./sqrt(sum(psd(:))) * (PROJdgn.fov/200)^3;
rsnr = rsnr*sqrt(3000/PROJdgn.nproj);                          % test
rsnr = rsnr/4;                                                  % scaling to match 'old SDC'

%---------------------------------------------
% Display / Return
%---------------------------------------------
if strcmp(Vis,'On')
    figure(200); hold on;
    PSDprof = squeeze(psd(:,(length(psd)+1)/2,(length(psd)+1)/2)); plot(PSDprof,'b'); 
    PSDprof = squeeze(psd((length(psd)+1)/2,:,(length(psd)+1)/2)); plot(PSDprof,'g'); 
    PSDprof = squeeze(psd((length(psd)+1)/2,(length(psd)+1)/2,:)); plot(PSDprof,'r'); 
    title('PSD Function'); xlabel('Matrix Diameter'); ylabel('Arb');
    ylim([0 max(psd(:))*1.1]); xlim([1 length(PSDprof)]);    
end

%---------------------------------------------
% Panel
%---------------------------------------------
Panel(1,:) = {'','','Output'};
Panel(2,:) = {'Method',PSDS.method,'Output'};
Panel(3,:) = {'rSNR (Brain 5-min PASS)',round(rsnr*(34/5.87)*10)/10,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);   

PSDS = rmfield(PSDS,'SDCS');
PSDS.rsnr = rsnr;
PSDS.psd = psd;
PSDS.kmatvol = elip*diam^3;
PSDS.psddiam = diam;
PSDS.Panel = Panel;
PSDS.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);
