%====================================================
% (pcd4a)
%   - for predetermined number of projections
%   - number of projections = multiple of 2
%   - over/under sampling split between phi and theta
%   - begin at pole
%   - extra projections on surrounding cones (selectable)
%====================================================

function [SCRPTipt,PROJDIST,err] = pcd4a_v1a(SCRPTipt,PROJDIST)

err.flag = 0;
eproj = SCRPTipt(strcmp('ExtraProj',{SCRPTipt.labelstr})).entrystr;

rad = PROJDIST.rad;
p = PROJDIST.p;
nproj0 = PROJDIST.nproj;

InitProjVec.pcd = 'pcd4a';
InitProjVec.sym = 2;
thnproj = round((4*pi*(rad)^2)*p);
InitProjVec.thnproj = thnproj;

done_phi = 0;
phi_dir = 1;
osamp_phi0 = 0;
nproj0 = 2*ceil(nproj0/2);                  % projections must be multiple of 2;
osamp_phi = sqrt(nproj0/thnproj);
osamp_theta = sqrt(nproj0/thnproj);
nproj = 0;
dir = 0;
fine = 2;

while not(nproj == nproj0)
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
    if nproj == nproj0
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
        elseif (nproj >= nproj0) && (phi_dir == 1) && not(osamp_phi0 == 0)
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
        elseif (nproj <= nproj0) && (phi_dir == 0) && not(osamp_phi0 == 0)
            osamp_phi = osamp_phi0;
            done_phi = 1;
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
InitProjVec.conephi = [phi pi-phi];
InitProjVec.projindx = projindx;
InitProjVec.ncones = ncones*2;
InitProjVec.nprojcone = [nprojcone nprojcone];
InitProjVec.osamp_phi = osamp_phi;
InitProjVec.osamp_theta = osamp_theta;
InitProjVec.projosamp = osamp_phi*osamp_theta;                  % projection oversample (spherical case)   
InitProjVec.nproj = nproj;                                            
PROJDIST.InitProjVec = InitProjVec;
PROJDIST.nproj = nproj;
PROJDIST.projosamp = InitProjVec.projosamp;
