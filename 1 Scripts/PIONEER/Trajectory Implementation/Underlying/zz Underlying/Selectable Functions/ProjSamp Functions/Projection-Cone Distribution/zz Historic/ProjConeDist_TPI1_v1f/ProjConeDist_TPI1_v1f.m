%====================================================
% (v1f)
%       - update for RWSUI_BA
%====================================================

function [SCRPTipt,PCDout,err] = ProjConeDist_TPI1_v1f(SCRPTipt,PCD)

Status2('busy','Deterime Projection Cone Distribution',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
PCDout = struct();
PCDout.eproj = PCD.('ExtraProj');
PCDout.phithetafrac0 = str2double(PCD.('Ph'));

%---------------------------------------------
% Unload Variables
%---------------------------------------------
PROJdgn = PCD.PROJdgn;

%---------------------------------------------
% Determine Distribution
%---------------------------------------------
rad = PROJdgn.rad;
p = PROJdgn.p;
nproj0 = PROJdgn.nproj;

PCDout.sym = 2;
thnproj = round((4*pi*(rad)^2)*p);
PCDout.thnproj = thnproj;

done_phi = 0;
phi_dir = 1;
osamp_phi0 = 0;
nproj0 = 2*ceil(nproj0/2);                  % projections must be multiple of 2;

osamp_phi = (nproj0/thnproj).^(1-PCDout.phithetafrac0);
osamp_theta = (nproj0/thnproj).^(PCDout.phithetafrac0);
nproj = 0;
dir = 0;
fine = 2;
readjustratio = 1;

phithetafrac = PCDout.phithetafrac0;
while not(nproj == nproj0)
    if readjustratio == 1
        osamp = osamp_phi*osamp_theta;
        osamp_phi = (osamp).^(1-phithetafrac);
        osamp_theta = (osamp).^(phithetafrac);
    end
    phi_step1 = pi/(2*ceil((pi*rad*osamp_phi)/2)-1);                                    
    phi = flipdim((0:phi_step1:pi/2),2);
    ncones = length(phi);                                                       % to cover half
    nprojcone = zeros(1,length(ncones));
    for i = 1:ncones
        if i == ncones
            nprojcone(i) = 1;
        end
        for a = 1:length(PCDout.eproj)
            if i == ncones-a
                nprojcone(i) = ceil(pi*sin(phi(i))*2*rad*p*osamp_theta)+str2double(PCDout.eproj(a)); 
            end
        end
        if i < ncones-length(PCDout.eproj) 
            nprojcone(i) = ceil(pi*sin(phi(i))*2*rad*p*osamp_theta); 
        end
    end
    nproj = 2*sum(nprojcone);
    if nproj == nproj0 && (rem(nprojcone(1),2))
        done_phi = 1;
    end
    if done_phi == 0
        if (nproj < nproj0) && (phi_dir == 1)  
            phi_dir = 1;
            ncones2 = ncones;
            osamp_phi0 = osamp_phi;
            while (ncones2 == ncones)
                phi_step1 = pi/(2*ceil((pi*rad*osamp_phi)/2)-1);                                    
                phi = flipdim((0:phi_step1:pi/2),2);
                ncones2 = length(phi);
                osamp_phi = osamp_phi + 0.01;
            end
        elseif (nproj >= nproj0) && (phi_dir == 1) && not(osamp_phi0 == 0) && (rem(nprojcone(1),2))
            osamp_phi = osamp_phi0;
            done_phi = 1;
        elseif (nproj > nproj0) && (phi_dir == 1) && (osamp_phi0 == 0)
            phi_dir = 0;
            ncones2 = ncones;
            osamp_phi0 = osamp_phi;
            while (ncones2 == ncones)
                phi_step1 = pi/(2*ceil((pi*rad*osamp_phi)/2)-1);                                    
                phi = flipdim((0:phi_step1:pi/2),2);
                ncones2 = length(phi);
                osamp_phi = osamp_phi - 0.01;
            end
        elseif (nproj > nproj0) && (phi_dir == 0)
            phi_dir = 0;
            ncones2 = ncones;
            osamp_phi0 = osamp_phi;
            while (ncones2 == ncones)
                phi_step1 = pi/(2*ceil((pi*rad*osamp_phi)/2)-1);                                    
                phi = flipdim((0:phi_step1:pi/2),2);
                ncones2 = length(phi);
                osamp_phi = osamp_phi - 0.01;
            end
        elseif (nproj <= nproj0) && (phi_dir == 0) && not(osamp_phi0 == 0) && (rem(nprojcone(1),2))
            osamp_phi = osamp_phi0;
            done_phi = 1;
        end
        if not(rem(nprojcone(1),2))
            osamp_phi = osamp_phi - 0.01;                                             
        end
   else
        if (nproj < nproj0)
            if dir == -1
                fine = fine + 1;
            end
            osamp_theta = osamp_theta + 1*10^(-fine);
            dir = 1;
        elseif (nproj > nproj0)
            if dir == 1
                fine = fine + 1;
            end
            osamp_theta = osamp_theta - 1*10^(-fine);
            dir = -1;
        end
        if not(rem(nprojcone(1),2))
            done_phi = 0;
            phithetafrac = phithetafrac - 0.001;
        end
    end
end

n = 1;
for i = 1:ncones
    projindx{i} = (n:n+nprojcone(i)-1);
    n = n+nprojcone(i);
end
for i = 1:ncones
    projindx{ncones+i} = (n:n+nprojcone(i)-1);
    n = n+nprojcone(i);
end

PCDout.conephi = [phi pi-phi];
PCDout.projindx = projindx;
PCDout.ncones = ncones*2;
PCDout.nprojcone = [nprojcone nprojcone];
PCDout.phithetafrac = phithetafrac;
PCDout.osamp_phi = osamp_phi;
PCDout.osamp_theta = osamp_theta;
PCDout.projosamp = osamp_phi*osamp_theta;                  % projection oversample (spherical case)   
PCDout.nproj = nproj;                                            

Status2('done','',2);

