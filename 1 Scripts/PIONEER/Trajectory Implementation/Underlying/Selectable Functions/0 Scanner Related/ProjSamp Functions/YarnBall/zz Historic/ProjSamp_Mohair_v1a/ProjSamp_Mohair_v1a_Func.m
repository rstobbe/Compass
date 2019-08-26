%====================================================
% 
%====================================================

function [PSMP,err] = ProjSamp_Mohair_v1a_Func(PSMP,INPUT) 

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
if strcmp(testing,'Yes')
    PSMP.phi = pi/2;
    PSMP.theta = 0;
else    
    %-----------------------------------------------
    % Calculate Projection Distributions
    %-----------------------------------------------
    goldenrat = (1+sqrt(5))/2;
    
    test = rem((4000:5000),goldenrat);
    figure(1235123);
    plot((4000:5000),test);
    
    %nproj = 4270;
    nproj = 4438;
    
    theta_step0 = nproj/goldenrat;
    theta_step1 = nproj*(2-goldenrat);
    test = theta_step0 + theta_step1;
    theta_step = theta_step1;
    %theta_step = 1634;
    theta(1) = 1;
    for n = 1:nproj
        theta(n+1) = rem((theta(n)+theta_step),nproj);
%         figure(12346); hold on;
%         plot(theta(n+1),1,'*');
%         xlim([0 4278]);
%         drawnow;
%         figure(134623);
%         histogram(theta);
    end
    
     sorttheta = sort(round(theta));
%     sortphi = sort(phi);
     figure(1234264); hold on;
     plot(sorttheta);
%     plot(sortphi);    
    
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
        set(gca,'cameraposition',[0 0 1]); 
        phi0 = IV(1,:);
        theta0 = IV(2,:);
        for n = 1:PSMP.nproj
            x = cos(theta0(n)).*sin(phi0(n));                             
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








