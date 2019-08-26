%====================================================
% 
%====================================================

function [PSMP,err] = ProjSamp_YarnBall_v2a_Func(PSMP,INPUT) 

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
% Distributions
%-----------------------------------------------
PSMP.ndiscs = SPIN.ndiscs;
PSMP.nspokes = SPIN.nspokes;
PSMP.nproj = SPIN.nproj;
PSMP.projosamp = 1;
PSMP.projsampscnr = (1:1:PSMP.nproj);

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
    theta_step = pi/PSMP.nproj;     
    theta = (theta_step:theta_step:pi);
    
    phi_step = (2*pi*PSMP.ndiscs + pi)/PSMP.nproj;     
    phi = pi/2+(phi_step:phi_step:phi_step*PSMP.nproj);
    
    IV(1,:) = phi;
    IV(2,:) = theta;
    PSMP.IV = IV;
    PSMP.phi = IV(1,:);
    PSMP.theta = IV(2,:);

    %---------------------------------------------
    % Visuals
    %--------------------------------------------- 
    visuals = 'on';
    if strcmp(visuals,'on')
        figure(50); hold on; hold on; axis equal; grid on; axis([-1 1 -1 1 -1 1]);
        %set(gca,'cameraposition',[-1000 -2000 300]); 
        set(gca,'cameraposition',[0 0 1]); 
        phi0 = IV(1,:);
        theta0 = IV(2,:);
        for n = 1:PSMP.nproj
            x = cos(theta0(n)).*sin(phi0(n));                             
            y = sin(theta0(n)).*sin(phi0(n));
            z = cos(phi0(n));
            if n == 1 || n == PSMP.nproj
                plot3([0 x],[0 y],[0 z],'linewidth',3);                  % should be beside
            else
                plot3([0 x],[0 y],[0 z]);
            end
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








