%====================================================
% (v2d)
%       - update for RWSUI_BA
%====================================================

function [SCRPTipt,PADout,err] = ProjAngleDist_TPI1_v2d(SCRPTipt,PAD,PCD)

Status2('busy','Deterime Projection Angle Distribution',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
PADout = struct();
PADout.Rnd = str2double(PAD.('Randomizer'));

%---------------------------------------------
% Unload Variables
%---------------------------------------------
ncones = PCD.ncones/2;
nprojcone = PCD.nprojcone(1:ncones);
phi = PCD.conephi(1:ncones);

%---------------------------------------------
% Determine Distribution
%---------------------------------------------
n = 1;
IV = 0;
for i = 1:ncones  
    thetastep(i) = 2*pi/nprojcone(i);
    if i == 1
        theta = (2*pi-thetastep(i)/2:-thetastep(i):0.0001);
        CAtheta(i) = {theta};
    elseif i == 2
        E = zeros(1,2*PADout.Rnd);
        for m = 1:2*PADout.Rnd
            theta = (2*pi-(m-1)*thetastep(i)/(2*PADout.Rnd):-thetastep(i):0.0001);
            for k = 1:nprojcone(i)
                ind1 = find(CAtheta{i-1} <= theta(k),1,'first');
                if isempty(ind1)
                    lval = CAtheta{i-1}(1) - 2*pi;
                else
                    lval = CAtheta{i-1}(ind1);
                end
                ind2 = find(CAtheta{i-1} > theta(k),1,'last');
                if isempty(ind2)
                    gval = CAtheta{i-1}(length(CAtheta{i-1})) + 2*pi;
                else
                    gval = CAtheta{i-1}(ind2);
                end
                E(m) = abs((gval - theta(k)))^2 + abs((lval - theta(k)))^2 + E(m);
            end
        end
        ind = find(E == min(E),1,'first');
        theta = (2*pi-(ind-1)*thetastep(i)/(2*PADout.Rnd):-thetastep(i):0.0001);
        CAtheta(i) = {theta};
    else
        E = zeros(1,2*PADout.Rnd);
        for m = 1:2*PADout.Rnd
            theta = (2*pi-(m-1)*thetastep(i)/(2*PADout.Rnd):-thetastep(i):0.0001);
            for k = 1:nprojcone(i)
                ind1 = find(CAtheta{i-1} <= theta(k),1,'first');
                if isempty(ind1)
                    lval = CAtheta{i-1}(1) - 2*pi;
                else
                    lval = CAtheta{i-1}(ind1);
                end
                ind2 = find(CAtheta{i-1} > theta(k),1,'last');
                if isempty(ind2)
                    gval = CAtheta{i-1}(length(CAtheta{i-1})) + 2*pi;
                else
                    gval = CAtheta{i-1}(ind2);
                end
                E(m) = abs((gval - theta(k)))^2 + abs((lval - theta(k)))^2 + E(m);
            end
        end
        ind = find(E == min(E),1,'first');
        theta = (2*pi-(ind-1)*thetastep(i)/(2*PADout.Rnd):-thetastep(i):0.0001);
        CAtheta(i) = {theta};       
    end
    IV(1,n:n+length(theta)-1) = phi(i);
    IV(2,n:n+length(theta)-1) = theta;
    n = n+length(theta);
end

IV(1,n:2*(n-1)) = pi - IV(1,1:n-1);        % symmetry (top - bottom)
%-----
IV(2,n:2*(n-1)) = IV(2,1:n-1) - pi;        % check pi ...
%-----

PADout.IV = IV;
PADout.thetastep = [thetastep thetastep];

Status2('done','',2);

