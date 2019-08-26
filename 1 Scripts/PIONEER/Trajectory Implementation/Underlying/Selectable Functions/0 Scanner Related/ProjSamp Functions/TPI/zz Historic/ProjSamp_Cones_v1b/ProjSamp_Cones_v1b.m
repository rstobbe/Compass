%====================================================
% 
%====================================================

function [SCRPTipt,PROJimp,err] = ProjSamp_Cones_v1b(SCRPTipt,SCRPTGBL,PROJimp,PROJdgn)

err.flag = 0;

pcd = SCRPTipt(strcmp('ProjConeDist',{SCRPTipt.labelstr})).entrystr;
pad = SCRPTipt(strcmp('ProjAngleDist',{SCRPTipt.labelstr})).entrystr;

%----------------------------------------------------
% Projection-Cone Distribution
%----------------------------------------------------  
func = str2func(pcd);   
[SCRPTipt,projdist,err] = func(SCRPTipt,PROJdgn);
if err.flag ~= 0
    return
end
PROJimp.nproj = PROJdgn.nproj;
PROJimp.projosamp = projdist.projosamp;

%[SCRPTipt] = AddToPanelOutput(SCRPTipt,'projosamp','0output',PROJimp.projosamp,'0numout');

if isfield(SCRPTGBL,'testing')
    if SCRPTGBL.testing == 1
        projdist.ncones = PROJimp.tnproj*2;
        projdist.nprojcone = ones(1,PROJimp.tnproj*2);                                 
        projdist.phi = flipdim((0:(pi/(2*PROJimp.tnproj-1)):pi/2),2);
        projdist.conephi = [projdist.phi projdist.phi];
        PROJimp.nproj = projdist.ncones;
    end
end

%----------------------------------------------------
% Projection-Angle Distribution
%----------------------------------------------------  
func = str2func(pad);   
[SCRPTipt,projdist,err] = func(SCRPTipt,projdist);
if err.flag ~= 0
    return
end

PROJimp.projdist = projdist;           

