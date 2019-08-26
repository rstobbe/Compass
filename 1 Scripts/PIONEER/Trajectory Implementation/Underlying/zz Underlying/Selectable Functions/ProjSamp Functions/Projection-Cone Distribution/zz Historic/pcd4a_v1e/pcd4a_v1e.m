%====================================================
% (v1e)
%   - make sure flattest CONES have odd number of trajs (all at end are odd).
%====================================================

function [SCRPTipt,projdist,err] = pcd4a_v1e(SCRPTipt,PROJdgn)

err.flag = 0;
eproj = SCRPTipt(strcmp('ExtraProj',{SCRPTipt.labelstr})).entrystr;
phithetafrac0 = str2double(SCRPTipt(strcmp('Phi(0)_Theta(1)',{SCRPTipt.labelstr})).entrystr);
phithetafrac = phithetafrac0;

rad = PROJdgn.rad;
p = PROJdgn.p;
nproj0 = PROJdgn.nproj;

projdist.sym = 2;
thnproj = round((4*pi*(rad)^2)*p);
projdist.thnproj = thnproj;

done_phi = 0;
phi_dir = 1;
osamp_phi0 = 0;
nproj0 = 2*ceil(nproj0/2);                  % projections must be multiple of 2;

osamp_phi = (nproj0/thnproj).^(1-phithetafrac);
osamp_theta = (nproj0/thnproj).^(phithetafrac);
nproj = 0;
dir = 0;
fine = 2;
readjustratio = 1;

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
        for a = 1:length(eproj)
            if i == ncones-a
                nprojcone(i) = ceil(pi*sin(phi(i))*2*rad*p*osamp_theta)+str2double(eproj(a)); 
            end
        end
        if i < ncones-length(eproj) 
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
osamp_theta = osamp_theta
osamp_phi = osamp_phi

if osamp_phi < 1 || osamp_theta < 1
    osamp_phi = osamp_phi
    osamp_theta = osamp_theta
    err.flag = 1;
    err.msg = 'increase #projs';
    return
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
projdist.conephi = [phi pi-phi];
projdist.projindx = projindx;
projdist.ncones = ncones*2;
projdist.nprojcone = [nprojcone nprojcone];
projdist.phithetafrac0 = phithetafrac0;
projdist.phithetafrac = phithetafrac;
projdist.osamp_phi = osamp_phi;
projdist.osamp_theta = osamp_theta;
projdist.projosamp = osamp_phi*osamp_theta;                  % projection oversample (spherical case)   
projdist.nproj = nproj;                                            

