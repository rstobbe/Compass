%====================================================
% 
%====================================================

function [PCD,err] = ProjConeDist_TPI4_v1k_Func(PCD,INPUT)

Status2('busy','Determine Projection Cone Distribution',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
clear INPUT

%---------------------------------------------
% Determine Distribution
%---------------------------------------------
rad = PROJdgn.rad;
p = PROJdgn.p;
nproj0 = PROJdgn.nproj;

PCD.sym = 2;
thnproj = round((4*pi*(rad)^2)*p);
PCD.thnproj = thnproj;

done_phi = 0;
phi_dir = 1;
osamp_phi0 = 0;
nproj0 = 2*ceil(nproj0/2);                  % projections must be multiple of 2;

phithetafrac = PCD.phithetafrac0;
if (nproj0/thnproj) < 1
    phithetafrac = 1 - phithetafrac;
end

osamp_phi = (nproj0/thnproj).^(1-phithetafrac);
osamp_theta = (nproj0/thnproj).^(phithetafrac);
nproj = 0;
theta_dir = 0;
fine = 2;
readjustratio = 1;

cntr = 0;
nprojcone = 0;
while not(nproj == nproj0) || not(rem(nprojcone(1),2))
    if readjustratio == 1
        osamp = osamp_phi*osamp_theta;
        osamp_phi = (osamp).^(1-phithetafrac);
        osamp_theta = (osamp).^(phithetafrac);
    end
    phi_step1 = pi/(2*ceil((pi*rad*osamp_phi)/2)-1);
    phi_step0 = pi/(2*ceil((pi*rad)/2)-1);
    minreldist = sin(phi_step0);
    minreldist = minreldist/PCD.phirateinc;
    phi = 0;
    n = 2;
    while true
        phi(n) = asin(minreldist + sin(phi(n-1)));
        phi_step = phi(n) - phi(n-1);
        if phi_step > phi_step1
            break
        end
        n = n+1;
    end
    remsteps = ceil((pi/2-phi(n-1))/phi_step1);
    phirem = linspace(phi(n),pi/2,remsteps);
    phi = [phi(1:n-1) phirem];
    phi = flipdim(phi,2);
    
    %figure(123); hold on;
    %plot(phi,'b*');
    %xlabel('cone number'); ylabel('phi');
    
    ncones = length(phi);                                                       % to cover half
    nprojcone = zeros(1,ncones);
    for i = 1:ncones
        if i == ncones
            nprojcone(i) = round(PCD.thetarateincnum) + 1;
        elseif i == ncones-1 || i == ncones-2
            nprojcone(i) = ceil(PCD.thetarateincnum*pi*sin(phi(i))*2*rad*p*osamp_theta) + 1;
        elseif phi(i) < pi*PCD.thetarateincdeg/180
            nprojcone(i) = ceil(PCD.thetarateincnum*pi*sin(phi(i))*2*rad*p*osamp_theta);
        else
            nprojcone(i) = ceil(pi*sin(phi(i))*2*rad*p*osamp_theta);
        end
    end
    for i = ncones-1:-1:1
        if nprojcone(i) < nprojcone(i+1);
            nprojcone(i) = nprojcone(i+1);
        end
    end
    nproj = 2*sum(nprojcone);
    if nproj == nproj0 && (rem(nprojcone(1),2))
        done_phi = 1;
    end
    if done_phi == 0
        if (nproj < nproj0) && (phi_dir == 1)  
            phi_dir = 1;
            osamp_phi0 = osamp_phi;
            osamp_phi = osamp_phi + 0.001;
        elseif (nproj >= nproj0) && (phi_dir == 1) && not(osamp_phi0 == 0)
            done_phi = 1;
        elseif (nproj > nproj0) && (phi_dir == 1) && (osamp_phi0 == 0)
            phi_dir = 0;
            osamp_phi0 = osamp_phi;
            osamp_phi = osamp_phi - 0.001;
        elseif (nproj > nproj0) && (phi_dir == 0)
            phi_dir = 0;
            osamp_phi0 = osamp_phi;
            osamp_phi = osamp_phi - 0.001;
        elseif (nproj <= nproj0) && (phi_dir == 0) && not(osamp_phi0 == 0)
            done_phi = 1;
        end
    else
        if (nproj < nproj0)
            if theta_dir == -1
                fine = fine + 1;
            end
            readjustratio = 0;
            osamp_theta = osamp_theta + 1*10^(-fine);
            theta_dir = 1;
        elseif (nproj > nproj0)
            if theta_dir == 1
                fine = fine + 1;
            end
            readjustratio = 0;
            osamp_theta = osamp_theta - 1*10^(-fine);
            theta_dir = -1;        
        elseif (nproj == nproj0) && not(rem(nprojcone(1),2))
            theta_dir = 0;
            fine = 2;
            done_phi = 0;
            readjustratio = 1;
            if phithetafrac < 0.5
                phithetafrac = phithetafrac + 0.001;
            else
                phithetafrac = phithetafrac - 0.001;
            end
        end
    end
    cntr = cntr + 1;
    if cntr == 10000
        err.flag = 1;
        err.msg = 'Did not Converge';
        return
    end
    %test_osamp_phi = osamp_phi
    %test_nproj = nproj
end


%figure(123);
%plot(phi,'r*');
%xlabel('cone number'); ylabel('phi');

n = 1;
for i = 1:ncones
    projindx{i} = (n:n+nprojcone(i)-1);
    n = n+nprojcone(i);
end
for i = 1:ncones
    projindx{ncones+i} = (n:n+nprojcone(i)-1);
    n = n+nprojcone(i);
end

PCD.conephi = [phi pi-phi];
PCD.projindx = projindx;
PCD.ncones = ncones*2;
PCD.nprojcone = [nprojcone nprojcone];
PCD.phithetafrac = phithetafrac;
PCD.osamp_phi = osamp_phi;
PCD.osamp_theta = osamp_theta;
PCD.projosamp = osamp_phi*osamp_theta;                  % projection oversample (spherical case)   
PCD.nproj = nproj;                                            

Status2('done','',2);
Status2('done','',3);
