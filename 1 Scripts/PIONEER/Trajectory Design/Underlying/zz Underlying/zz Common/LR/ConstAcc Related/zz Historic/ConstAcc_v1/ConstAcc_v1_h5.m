%==================================================
% Constrain Acceleration
% - graphing solution
%==================================================

function [Tsegs,vel,acc] = ConstAcc_v1(KSA,AccProf)

Tsegs = zeros(length(KSA),1);
vel = zeros(size(KSA));
acc = zeros(size(KSA));

Tsegs(2) = sqrt(2*sqrt(KSA(2,1).^2 + KSA(2,2).^2 + KSA(2,3).^2)/AccProf(1));            %length of first seg...
%Tsegs(2) = Tsegs(2)*5;
vel(2,1) = 2*KSA(2,1)/Tsegs(2);
vel(2,2) = 2*KSA(2,2)/Tsegs(2);
vel(2,3) = 2*KSA(2,3)/Tsegs(2); 

acc(2,1) = 2*KSA(2,1)/(Tsegs(2)^2);
acc(2,2) = 2*KSA(2,2)/(Tsegs(2)^2);
acc(2,3) = 2*KSA(2,3)/(Tsegs(2)^2);

for n = 3:length(KSA)

    if n == 100
        here = 1;
    end
    
    t = linspace(0.25*Tsegs(n-1),3*Tsegs(n-1),1000);
    accx = 2*((KSA(n,1)-KSA(n-1,1)) - vel(n-1,1)*t)./(t.^2);
    accy = 2*((KSA(n,2)-KSA(n-1,2)) - vel(n-1,2)*t)./(t.^2);
    accz = 2*((KSA(n,3)-KSA(n-1,3)) - vel(n-1,3)*t)./(t.^2);    
    magacc = sqrt(accx.^2 + accy.^2 + accz.^2);    
    
    figure(251); plot(t,magacc); ylim([0 6000]);

    if min(magacc) < 500
        ind = find(magacc < AccProf(1),1,'first');
        t1 = t(ind);
    elseif min(magacc) > 500 
        ind = find(magacc < AccProf(1),1,'last');
        t1 = t(ind);
    end
    acc(n,1) = 2*((KSA(n,1)-KSA(n-1,1)) - vel(n-1,1)*t1)/(t1^2);
    acc(n,2) = 2*((KSA(n,2)-KSA(n-1,2)) - vel(n-1,2)*t1)/(t1^2);
    acc(n,3) = 2*((KSA(n,3)-KSA(n-1,3)) - vel(n-1,3)*t1)/(t1^2);    
    magacc = sqrt(acc(n,1).^2 + acc(n,2).^2 + acc(n,3).^2)
    vel(n,1) = vel(n-1,1) + acc(n,1)*t1;
    vel(n,2) = vel(n-1,2) + acc(n,2)*t1;
    vel(n,3) = vel(n-1,3) + acc(n,3)*t1;
    magvel = sqrt(vel(n,1).^2 + vel(n,2).^2 + vel(n,3).^2)
    Tsegs(n) = t1;
    n
end
magacc = sqrt(acc(:,1).^2 + acc(:,2).^2 + acc(:,3).^2);
figure(252); plot(magacc);
figure(253); plot(Tsegs);

test = sum(Tsegs)

