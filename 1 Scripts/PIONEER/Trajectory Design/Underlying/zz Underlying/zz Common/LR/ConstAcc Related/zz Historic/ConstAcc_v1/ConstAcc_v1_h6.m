%==================================================
% Constrain Acceleration
%   - velocity steps...
%==================================================

function [Tsegs,vel,acc] = ConstAcc_v1(KSA,AccProf)

%Tsegs = zeros(length(KSA),1);
%vel = zeros(size(KSA));
acc = zeros(size(KSA));

mvstep = 18.75;  %0.003125
Tsegs(2) = sqrt((KSA(2,1))^2 + (KSA(2,2))^2 + (KSA(2,3))^2)/mvstep;
    
vel(2,1) = KSA(2,1)/Tsegs(2);
vel(2,2) = KSA(2,2)/Tsegs(2);
vel(2,3) = KSA(2,3)/Tsegs(2); 
magvstep = sqrt(vel(2,1)^2 + vel(2,2)^2 + vel(2,3)^2); 

for n = 3:length(KSA)
    if n == 913
        here = 0;
    end
    t = linspace(0,1.5*Tsegs(n-1),1000);
    magvstep = sqrt(((KSA(n,1)-KSA(n-1,1))./t-vel(n-1,1)).^2 + ((KSA(n,2)-KSA(n-1,2))./t-vel(n-1,2)).^2 + ((KSA(n,3)-KSA(n-1,3))./t-vel(n-1,3)).^2);
    %figure(251); plot(t,magvstep);
    ind = find(magvstep < mvstep,1,'first');
    if isempty(ind)
        %ind = find(magvstep == min(magvstep),1,'first');
        n
        figure(251); plot(t,magvstep);
        figure(252); plot(magvel);
        figure(253); plot(Tsegs);
        figure(254); plot(KSA(1:n,1));
        figure(255); plot(KSA(1:n,2));
        figure(256); plot(KSA(1:n,3));
        figure(257); plot(vel(1:n-1,1));
        figure(258); plot(vel(1:n-1,2));
        figure(259); plot(vel(1:n-1,3));
        mvstep
        error
    end
    Ttemp = t(ind);
    if Ttemp < 0.003125
        mvstep = AccProf(n)*Ttemp;
        ind = find(magvstep < mvstep,1,'first');
        if isempty(ind)
            %ind = find(magvstep == min(magvstep),1,'first');
            n
            figure(251); plot(t,magvstep);
            figure(252); plot(magvel);
            figure(253); plot(Tsegs);
            figure(254); plot(KSA(1:n,1));
            figure(255); plot(KSA(1:n,2));
            figure(256); plot(KSA(1:n,3));
            figure(257); plot(vel(1:n-1,1));
            figure(258); plot(vel(1:n-1,2));
            figure(259); plot(vel(1:n-1,3));
            mvstep
            error
        end
    end
    Tsegs(n) = t(ind);
    vel(n,1) = (KSA(n,1)-KSA(n-1,1))/Tsegs(n);
    vel(n,2) = (KSA(n,2)-KSA(n-1,2))/Tsegs(n);
    vel(n,3) = (KSA(n,3)-KSA(n-1,3))/Tsegs(n);
    magvel(n) = sqrt(vel(n,1)^2 + vel(n,2)^2 + vel(n,3)^2); 

    magvelstep(n) = sqrt((vel(n,1)-vel(n-1,1))^2 + (vel(n,2)-vel(n-1,2))^2 + (vel(n,3)-vel(n-1,3))^2);
    
end
    
figure(251); plot(magvelstep./Tsegs);

