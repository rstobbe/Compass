%====================================================
% 
%====================================================

function [PSMP,err] = ProjSamp_DiscsTemplate_v1a_Func(PSMP,INPUT) 

Status2('busy','Calculate Projection Distribution',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;

%---------------------------------------------
% Common Variables
%---------------------------------------------
nproj = PROJdgn.nproj;

%-----------------------------------------------
% Test nproj for even distribution
%-----------------------------------------------
ndiscs = ceil(sqrt(nproj/2));
nppd = ndiscs*2;
PSMP.ndiscs = ndiscs;
PSMP.nppd = nppd;
PSMP.nproj = ndiscs*nppd;
if PSMP.nproj ~= nproj
    err.flag = 1;
    err.msg = '''Nproj'' must be function of 2*(integer^2)';
    return
end

%-----------------------------------------------
% Calculate Projection Distributions
%-----------------------------------------------
theta_step = pi/ndiscs;                                                              
theta = (pi-theta_step/2:-theta_step:theta_step/2);
if length(theta) ~= ndiscs
    error();
end
phi_step = 2*pi/nppd;                                                              
phi = (2*pi-phi_step/2:-phi_step:phi_step/2);
if length(phi) ~= nppd
    error();
end
IV(1,:) = phi;
IV(2,:) = theta(1);
PSMP.IV = IV;
PSMP.phi = IV(1,:);
PSMP.theta = IV(2,:);
PSMP.rottemptheta = theta;

%---------------------------------------------
% Visuals
%--------------------------------------------- 
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

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'ndiscs',PSMP.ndiscs,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
PSMP.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);








