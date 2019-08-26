%====================================================
% 
%====================================================

function [SCRPTipt,PROJimp,err] = ProjSampConesRCOS_v1a(SCRPTipt,SCRPTGBL,PROJimp,PROJdgn)

err.flag = 0;

pcd = SCRPTipt(strcmp('ProjConeDist',{SCRPTipt.labelstr})).entrystr;
pad = SCRPTipt(strcmp('ProjAngleDist',{SCRPTipt.labelstr})).entrystr;
rstdevphi = str2double(SCRPTipt(strcmp('rStdevPhi',{SCRPTipt.labelstr})).entrystr);
rstdevtheta = str2double(SCRPTipt(strcmp('rStdevTheta',{SCRPTipt.labelstr})).entrystr);

%----------------------------------------------------
% Projection-Cone Distribution
%----------------------------------------------------  
func = str2func(pcd);   
[SCRPTipt,projdist,projdistrc,err] = func(SCRPTipt,PROJdgn);
if err.flag ~= 0
    return
end
PROJimp.nproj = PROJdgn.nproj;
PROJimp.projosamp = projdist.projosamp;
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'projosamp','0output',PROJimp.projosamp,'0numout');

if SCRPTGBL.testing == 1
    projdist.ncones = PROJimp.tnproj*2;
    projdist.nprojcone = ones(1,PROJimp.tnproj*2);                                 
    projdist.phi = flipdim((0:(pi/(2*PROJimp.tnproj-1)):pi/2),2);
    projdist.conephi = [projdist.phi projdist.phi];
    PROJimp.nproj = projdist.ncones;
end

%----------------------------------------------------
% Projection-Angle Distribution
%----------------------------------------------------  
func = str2func(pad);   
[SCRPTipt,projdist,projdistrc,err] = func(SCRPTipt,projdist,projdistrc);
if err.flag ~= 0
    return
end
PROJimp.nprojrc = projdistrc.nproj;
[SCRPTipt] = AddToPanelOutput(SCRPTipt,'nrpojrc','0output',PROJimp.nprojrc,'0numout');

%----------------------------------------------------
% Randomize
%----------------------------------------------------  
phi = projdist.IV(1,:);
theta = projdist.IV(2,:);

figure(1); hold on;
plot(phi,theta,'b*');

phistep = phi(length(phi)) - phi(length(phi)-1);
phi = phi + rstdevphi*phistep*randn(1,length(phi));
phi(length(phi)) = pi;
phi(length(phi)/2) = 0;

projdist.thetastep(projdist.thetastep == 2*pi) = 0;

for n = 1:projdist.ncones
    theta(projdist.projindx{n}) = theta(projdist.projindx{n}) + rstdevtheta*projdist.thetastep(n)*randn(1,length(projdist.projindx{n}));
end

figure(1); hold on;
plot(phi,theta,'r*');

%error();
projdist.IV(1,:) = phi;
projdist.IV(2,:) = theta;
projdist.rstdevthetha = rstdevtheta; 
projdist.rstdevthetha = rstdevphi; 
projdist.pcd = pcd; 
projdist.pad = pad; 

%----------------------------------------------------
% Make Full Array
%---------------------------------------------------- 
projdist.IV = [projdist.IV projdistrc.IV]; 
phi = projdistrc.IV(1,:);
theta = projdistrc.IV(2,:);
figure(1); hold on;
plot(phi,theta,'g*');

PROJimp.projdist = projdist;   
PROJimp.projdistrc = projdistrc; 
