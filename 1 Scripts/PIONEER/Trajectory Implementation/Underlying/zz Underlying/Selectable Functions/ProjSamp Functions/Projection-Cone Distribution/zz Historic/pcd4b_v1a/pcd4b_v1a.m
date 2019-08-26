%====================================================
% (pcd4)
%   - for predetermined number of projections
%   - number of projections = multiple of 2
%   - over/under sampling split between phi and theta
%   - extra projections on surrounding cones (selectable)
% (b)
%   - uses 'conephi' from (a) to get projections at half-step from pole
% (v1a)
%====================================================

function [SCRPTipt,projdistout,err] = pcd4b_v1a(SCRPTipt,projdistin,PROJdgn)

err.flag = 0;
eproj = SCRPTipt(strcmp('ExtraProj',{SCRPTipt.labelstr})).entrystr;

rad = PROJdgn.rad;
p = PROJdgn.p;

projdistout.pcd = 'pcd4b';

phi1 = projdistin.conephi(1:length(projdistin.conephi)/2);
phistep = phi1(1) - phi1(2);
phi1 = phi1 + phistep/2;
ncones1 = length(phi1);                                                       % half
cn = 1;
pn = 1;
for i = 1:ncones1
    if i == ncones1
        nprojcone(cn) = 1;
    end
    for a = 1:length(eproj)
        if i == ncones1-a
            nprojcone(cn) = ceil(pi*sin(phi1(i))*2*rad*p*projdistin.osamp_theta)+str2double(eproj(a)); 
        end
    end
    if i < ncones1-length(eproj) 
        nprojcone(cn) = ceil(pi*sin(phi1(i))*2*rad*p*projdistin.osamp_theta); 
    end
    projindx{cn} = (pn:pn+nprojcone(cn)-1);
    pn = pn+nprojcone(cn);
    cn = cn+1;
end

phi2 = pi-phi1(2:length(phi1))
ncones2 = length(phi2); 
for i = 1:ncones2
    if i == ncones2
        nprojcone(cn) = 1;
    end
    for a = 1:length(eproj)
        if i == ncones2-a
            nprojcone(cn) = ceil(pi*sin(phi2(i))*2*rad*p*projdistin.osamp_theta)+str2double(eproj(a)); 
        end
    end
    if i < ncones2-length(eproj) 
        nprojcone(cn) = ceil(pi*sin(phi2(i))*2*rad*p*projdistin.osamp_theta); 
    end
    projindx{cn} = (pn:pn+nprojcone(cn)-1);
    pn = pn+nprojcone(cn);
    cn = cn+1;
end

projdistout.conephi = [phi1 phi2];
projdistout.projindx = projindx;
projdistout.ncones = ncones1+ncones2;
projdistout.nprojcone = nprojcone;
projdistout.nproj = pn - 1;                                            

