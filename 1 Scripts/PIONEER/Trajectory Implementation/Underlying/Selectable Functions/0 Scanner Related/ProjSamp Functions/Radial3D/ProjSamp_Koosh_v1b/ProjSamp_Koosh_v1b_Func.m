%====================================================
% 
%====================================================

function [PSMP,err] = ProjSamp_Koosh_v1b_Func(PSMP,INPUT) 

Status2('busy','Calculate Projection Distribution',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
testing = INPUT.testing;
PROJdgn = INPUT.PROJdgn;
clear INPUT;

%---------------------------------------------
% Not Used
%---------------------------------------------
if strcmp(testing,'Yes')
    error();        % not used
end

%---------------------------------------------
% Calculate Projection Distributions
%---------------------------------------------
PSMP.thnproj = round(4*pi*(PROJdgn.rad)^2);
PSMP.projosamp = (PROJdgn.nproj-1)/PSMP.thnproj;
P1 = sqrt(PROJdgn.nproj*pi);

for n = 1:PROJdgn.nproj
    Pz = ((2*n)-PROJdgn.nproj-1)/PROJdgn.nproj; 
    Px = cos(P1*asin(Pz))*sqrt(1-Pz^2);
    Py = sin(P1*asin(Pz))*sqrt(1-Pz^2);

    %Pr = sqrt(Pz^2 + Py^2 + Px^2);
    Pr = 1;
    phi(n) = acos(Pz/Pr);    
    theta0 = atan(Py/Px);
    if isnan(theta0)
        theta(n) = 0;
    else
        if sign(Px) < 0
            theta(n) = pi + theta0;
        else 
            theta(n) = theta0;
        end
    end
end

PSMP.IV(1,:) = real(phi); 
PSMP.IV(2,:) = real(theta);
PSMP.phi = real(phi);
PSMP.theta = real(theta);
PSMP.nproj = PROJdgn.nproj;

%---------------------------------------------
% Visuals
%--------------------------------------------- 
visuals = 'off';
if strcmp(visuals,'on')
    figure(50); hold on; hold on; axis equal; grid on; axis([-1 1 -1 1 -1 1]);
    set(gca,'cameraposition',[5 10 5]); 
    phi0 = PSMP.IV(1,:);
    theta0 = PSMP.IV(2,:);
    for n = 1:PROJdgn.nproj
        x = cos(theta0(n)).*sin(phi0(n));                             
        y = sin(theta0(n)).*sin(phi0(n));
        z = cos(phi0(n));
        plot3([0 x],[0 y],[0 z]);
        pause(0.0001);
    end
end
   
%---------------------------------------------
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {PSMP.method,'','Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
PSMP.PanelOutput = PanelOutput;

Status2('done','',2);
Status2('done','',3);








