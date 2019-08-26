%====================================================
% 
%====================================================


function [SCRPTipt,PROJDIST,err] = Discs_v1a(SCRPTipt,PROJDIST) 

err.flag = 0;

%-----------------------------------------------
% Recalculate nproj for even distribution
%-----------------------------------------------
ndiscs = ceil(sqrt(PROJDIST.nproj/2));
nppd = ndiscs*2;
PROJDIST.ndiscs = ndiscs;
PROJDIST.nppd = nppd;
PROJDIST.nproj = ndiscs*nppd;

%-----------------------------------------------
% Calculate Projection Distributions
%-----------------------------------------------
theta_step = pi/ndiscs;                                                              
theta = (pi-theta_step/2:-theta_step:0);
ndiscs = length(theta);
n = 1;
IV = 0;
for i = 1:ndiscs
    phi_step = 2*pi/nppd;                           % oversample if fraction                                     
    phi = (2*pi-phi_step/2:-phi_step:phi_step/2);
    IV(1,n:n+length(phi)-1) = phi;
    IV(2,n:n+length(phi)-1) = theta(i);
    n = n+length(phi);
end
PROJDIST.IV = IV;

visuals = 'off';
if not(strcmp(visuals,'off'))
    figure(50); hold on; hold on; axis equal; grid on; axis([-1 1 -1 1 -1 1]);
    set(gca,'cameraposition',[-1000 -2000 300]); 
    phi0 = IV(1,:);
    theta0 = IV(2,:);
    for n = 1:PROJDIST.nproj
        x = cos(theta0(n)).*sin(phi0(n));                              % design location of each point in k-space
        y = sin(theta0(n)).*sin(phi0(n));
        z = cos(phi0(n));
        plot3([0 x],[0 y],[0 z]);
        pause(0.001);
    end
end










