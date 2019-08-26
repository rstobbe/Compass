%====================================================
% pad2a
%   - each cone shifted to minimize the proximity to the previous cone
% (v2a)
%   - visualization removal - can plot externally
%====================================================

function [SCRPTipt,PROJDIST,err] = pad2a_v2a(SCRPTipt,PROJDIST)

err.flag = 0;
T = str2double(SCRPTipt(strcmp('Randomizer',{SCRPTipt.labelstr})).entrystr);

InitProjVec = PROJDIST.InitProjVec;
ncones = InitProjVec.ncones/2;
nprojcone = InitProjVec.nprojcone(1:ncones);
phi = InitProjVec.conephi(1:ncones);
rad = PROJDIST.rad;

%T = InitProjVec.randomizer;
n = 1;
IV = 0;
for i = 1:ncones  
    theta_step = 2*pi/nprojcone(i);
    if i == 1
        theta = (2*pi-theta_step/2:-theta_step:0.0001);
        CAtheta(i) = {theta};
    elseif i == 2
        E = zeros(1,2*T);
        for m = 1:2*T
            theta = (2*pi-(m-1)*theta_step/(2*T):-theta_step:0.0001);
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
        theta = (2*pi-(ind-1)*theta_step/(2*T):-theta_step:0.0001);
        CAtheta(i) = {theta};
    else
        E = zeros(1,2*T);
        for m = 1:2*T
            theta = (2*pi-(m-1)*theta_step/(2*T):-theta_step:0.0001);
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
        theta = (2*pi-(ind-1)*theta_step/(2*T):-theta_step:0.0001);
        CAtheta(i) = {theta};       
    end
    IV(1,n:n+length(theta)-1) = phi(i);
    IV(2,n:n+length(theta)-1) = theta;
    n = n+length(theta);
end

IV(1,n:2*(n-1)) = pi - IV(1,1:n-1);                                         % symmetry (top - bottom)
%-----
IV(2,n:2*(n-1)) = pi + IV(2,1:n-1);  % check whether addind pi a good idea...
%-----

PROJDIST.IV = IV;
PROJDIST.rand = T;
