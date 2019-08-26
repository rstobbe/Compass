%===========================================
% 
%===========================================

function [SUS,err] = SUSBuild_TPIdes_v1a_Func(SUS,INPUT)

Status2('busy','Create Susceptibility Transfer Function',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Input
%---------------------------------------------
if SUS.offres == 0
    SUS.tf = [];
    return
end

%---------------------------------------------
% Load Input
%---------------------------------------------
PROJdgn = INPUT.IMP.impPROJdgn;
diam = INPUT.tfdiam;
orient = INPUT.tforient;
Vis = INPUT.vis;
clear INPUT

%---------------------------------------------
% Variables / Structures
%---------------------------------------------
SUS.r = PROJdgn.r;
SUS.tatr = PROJdgn.tatr;
SUS.elip = PROJdgn.elip;

R = diam/2;
Ksz = 2*ceil(R)+1;   
C = (Ksz+1)/2;
tf = zeros(Ksz,Ksz,Ksz);
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
                rmax = sqrt(((SUS.elip*R)^2)/(SUS.elip^2*(sin(phi))^2 + (cos(phi))^2));
                r = r0/rmax;
            end
            if r <= 1
                tatr = interp1(SUS.r,SUS.tatr,r,'linear','extrap');
                %test = angle(exp(1i*2*pi*tatr*SUS.offres/1000));
                tf(x,y,z) = exp(1i*2*pi*tatr*SUS.offres/1000);
                Tot = Tot + 1;
            end
        end
    end
end

compV = SUS.elip*pi*(4/3)*R.^3;
Dif = compV/Tot;
if abs((1-Dif)*100) > 2
    err.flag = 1;
    err.msg = 'Spheroid Creation More than 2% in error (increase matrix dimension)';
    return
end

if strcmp(orient,'Sagittal')
    tf = permute(tf,[3 2 1]);
elseif strcmp(orient,'Coronal')
    tf = permute(tf,[1 3 2]);
end

if strcmp(Vis,'On')
    SUSprof = squeeze(tf((length(tf)+1)/2,(length(tf)+1)/2,:));
    figure(110); hold on; plot(angle(SUSprof),'k','linewidth',2); 
    ylim([0 2]); xlim([1 length(SUSprof)]); 
    title('Susceptibility Function Profile');
    ylabel('Phase Accumulation (rads)');
    xlabel('k-Matrix Point');
end

SUS.tf = tf;

Status2('done','',3);

