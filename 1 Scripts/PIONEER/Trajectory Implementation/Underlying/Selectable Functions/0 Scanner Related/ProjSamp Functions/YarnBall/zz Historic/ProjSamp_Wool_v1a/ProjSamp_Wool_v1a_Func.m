%====================================================
% 
%====================================================

function [PSMP,err] = ProjSamp_Wool_v1a_Func(PSMP,INPUT) 

Status2('busy','Calculate Projection Distribution',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
SPIN = INPUT.SPIN;
testing = INPUT.testing;
clear INPUT;

%-----------------------------------------------
% Test nproj for even distribution
%-----------------------------------------------
if not(SPIN.AziSampUsed >= 0.95)
    err.flag = 1;
    err.msg = '''ProjSamp_Wool'' only valid for polar undersampling';
    return
end
if SPIN.PolSampUsed >= 0.95
    polreconosampfact = 1;
else
    polreconosampfact = ceil(1/SPIN.PolSampUsed);
end
azireconosampfact = 1;

ndiscs = SPIN.ndiscs*azireconosampfact;
nppd = SPIN.nspokes*polreconosampfact;
    
PSMP.ndiscs = ndiscs;
PSMP.nppd = nppd;
PSMP.nproj = ndiscs*nppd;
PSMP.projosamp = (PSMP.nproj/SPIN.nproj)*(SPIN.AziSampUsed*SPIN.PolSampUsed);                   % oversampling in the recon...                  
PSMP.azireconosampfact = azireconosampfact;
PSMP.polreconosampfact = polreconosampfact;
PSMP.projsampscnr = (1:polreconosampfact:PSMP.nproj);

%---------------------------------------------
% Create Vectors
%---------------------------------------------
if strcmp(testing,'Yes');
    PSMP.phi = pi/2;
    PSMP.theta = 0;
else    
    %-----------------------------------------------
    % Calculate Projection Distributions
    %-----------------------------------------------
    theta_step = pi/ndiscs;                                                              
    theta = (pi-theta_step/2:-theta_step:0);
    ndiscs = length(theta);
    n = 1;
    IV = 0;
    for i = 1:ndiscs
        phi_step = 2*pi/nppd;                                                              
        phi = (2*pi-phi_step/2:-phi_step:phi_step/2);
        IV(1,n:n+length(phi)-1) = phi;
        IV(2,n:n+length(phi)-1) = theta(i);
        n = n+length(phi);
    end
    PSMP.IV = IV;
    PSMP.phi = IV(1,:);
    PSMP.theta = IV(2,:);

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
end
    
%---------------------------------------------
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'Design Ndiscs',SPIN.ndiscs,'Output'};
Panel(2,:) = {'Design Nspokes',SPIN.nspokes,'Output'};
Panel(3,:) = {'Recon Nproj',PSMP.nproj,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
PSMP.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);








