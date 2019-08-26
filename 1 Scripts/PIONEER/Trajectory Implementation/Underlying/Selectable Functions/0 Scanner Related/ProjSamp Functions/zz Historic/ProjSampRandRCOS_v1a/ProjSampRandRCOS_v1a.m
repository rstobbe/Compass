%====================================================
% 
%====================================================

function [SCRPTipt,PROJimp,err] = ProjSampRandRCOS_v1a(SCRPTipt,SCRPTGBL,PROJimp,PROJdgn)

err.flag = 0;
RCOS = str2double(SCRPTipt(strcmp('RCOS',{SCRPTipt.labelstr})).entrystr);

projdist.sym = 1;
rad = PROJdgn.rad;
p = PROJdgn.p;
projdist.thnproj = round((4*pi*(rad)^2)*p);
projdist.RCOS = RCOS;
totalprojs = round(projdist.thnproj*RCOS);
PROJimp.nprojrc = totalprojs - PROJdgn.nproj;

if SCRPTGBL.testing == 1
    PROJimp.nproj = PROJimp.tnproj;
    projdist.IV(1,:) = linspace(0,pi/2,PROJimp.nproj);
    projdist.IV(2,:) = zeros(1,PROJimp.nproj);
else
    PROJimp.nproj = PROJdgn.nproj;
    projdist.IV(1,:) = acos(2*rand(1,totalprojs)-1);
    projdist.IV(2,:) = 2*pi*rand(1,totalprojs);
end
PROJimp.projdist = projdist;

[SCRPTipt] = AddToPanelOutput(SCRPTipt,'nprojrc','0output',PROJimp.nprojrc,'0numout');

%phivalues = acos(2*rand(1,10000000)-1);
%figure(2)
%hist(values,40);