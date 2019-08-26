%====================================================
% 
%====================================================

function [SCRPTipt,PROJimp,err] = ProjSamp_v1a(SCRPTipt,SCRPTGBL,PROJimp,PROJdgn)

err.flag = 0;

projdist.pcd = 'pcd4a_v1b';
projdist.pad = 'pad2a_v2b';

%----------------------------------------------------
% Projection-Cone Distribution
%----------------------------------------------------  
if SCRPTGBL.testing == 1
    projdist.ncones = PROJimp.tnproj*2;
    projdist.nprojcone = ones(1,PROJimp.tnproj*2);                                 
    projdist.phi = flipdim((0:(pi/(2*PROJimp.tnproj-1)):pi/2),2);
    projdist.conephi = [projdist.phi projdist.phi];
    PROJimp.nproj = projdist.ncones;
else
    func = str2func(projdist.pcd);   
    [SCRPTipt,projdist,err] = func(SCRPTipt,projdist,PROJdgn);
    if err.flag ~= 0
        return
    end
    PROJimp.nproj = PROJdgn.nproj;
    PROJimp.projosamp = projdist.projosamp;
end

%----------------------------------------------------
% Projection-Angle Distribution
%----------------------------------------------------  
func = str2func(projdist.pad);   
[SCRPTipt,projdist,err] = func(SCRPTipt,projdist);
if err.flag ~= 0
    return
end

PROJimp.projdist = projdist;           

