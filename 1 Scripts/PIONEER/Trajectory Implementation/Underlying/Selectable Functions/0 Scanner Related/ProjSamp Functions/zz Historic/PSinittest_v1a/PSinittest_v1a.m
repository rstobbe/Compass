%====================================================
% (PSinittest_v1a)
%====================================================

function [SCRPTipt,PROJimp,err] = PSinittest_v1a(SCRPTipt,SCRPTGBL,PROJimp,PROJdgn)

err.flag = 0;
rcOS = str2double(SCRPTipt(strcmp('ReconOS',{SCRPTipt.labelstr})).entrystr);

projdist.pcd = 'pcd4a_v1b';
projdist.pcdrc = 'pcd4b_v1a';
projdist.pad = 'pad2a_v2b';
projdist.padrc = 'pad2b_v1a';

%====================================================
% Implemented Set (projdist0)
%====================================================

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

PROJimp.projdist0 = projdist;           

%====================================================
% ReCon Set (projdistrc)
%====================================================

%----------------------------------------------------
% ReCon Set (projdistrc)
%----------------------------------------------------
if SCRPTGBL.testing == 0
    func = str2func(projdist.pcdrc);   
    [SCRPTipt,projdistrc,err] = func(SCRPTipt,projdist,PROJdgn);
    if err.flag ~= 0
        return
    end
    PROJimp.nprojrc = projdistrc.nproj;
else
    PROJimp.projdistrc = struct();
    PROJimp.nprojrc = 0;
    return
end

%----------------------------------------------------
% Projection-Angle Distribution
%----------------------------------------------------  
func = str2func(projdist.padrc);   
[SCRPTipt,projdistrc,err] = func(SCRPTipt,projdistrc);
if err.flag ~= 0
    return
end

PROJimp.projdistrc = projdistrc;
