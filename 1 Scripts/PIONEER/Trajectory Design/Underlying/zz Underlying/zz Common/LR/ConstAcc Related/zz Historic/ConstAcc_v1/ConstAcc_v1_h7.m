%==================================================
% Constrain Acceleration
%==================================================

function [Tsegs,vel,acc] = ConstAcc_v1(KSA,AccProf)

%Tsegs = zeros(length(KSA),1);
%vel = zeros(size(KSA));
%acc = zeros(size(KSA));

mvstep = 18.75;  %0.003125
Tsegs(2) = sqrt((KSA(2,1))^2 + (KSA(2,2))^2 + (KSA(2,3))^2)/mvstep;
    
vel(2,1) = KSA(2,1)/Tsegs(2);
vel(2,2) = KSA(2,2)/Tsegs(2);
vel(2,3) = KSA(2,3)/Tsegs(2); 
magvstep = sqrt(vel(2,1)^2 + vel(2,2)^2 + vel(2,3)^2); 

acc(2,1) = vel(2,1)/Tsegs(2);
acc(2,2) = vel(2,2)/Tsegs(2);
acc(2,3) = vel(2,3)/Tsegs(2);   
magacc(2) = sqrt(acc(2,1).^2 + acc(2,2).^2 + acc(2,3).^2);

for n = 3:length(KSA)
    vel(n,1) = (KSA(n,1)-KSA(n-1,1))/Tsegs(n-1);
    vel(n,2) = (KSA(n,2)-KSA(n-1,2))/Tsegs(n-1);
    vel(n,3) = (KSA(n,3)-KSA(n-1,3))/Tsegs(n-1);
    acc(n,1) = (vel(n,1)-vel(n-1,1))/Tsegs(n-1);
    acc(n,2) = (vel(n,2)-vel(n-1,2))/Tsegs(n-1);
    acc(n,3) = (vel(n,3)-vel(n-1,3))/Tsegs(n-1); 
    magacc(n) = sqrt(acc(n,1).^2 + acc(n,2).^2 + acc(n,3).^2);
    Tsegs(n) = sqrt(magacc(n)/AccProf(n));
    vel(n,1) = (KSA(n,1)-KSA(n-1,1))/Tsegs(n);
    vel(n,2) = (KSA(n,2)-KSA(n-1,2))/Tsegs(n);
    vel(n,3) = (KSA(n,3)-KSA(n-1,3))/Tsegs(n);
    acc(n,1) = (vel(n,1)-vel(n-1,1))/Tsegs(n);
    acc(n,2) = (vel(n,2)-vel(n-1,2))/Tsegs(n);
    acc(n,3) = (vel(n,3)-vel(n-1,3))/Tsegs(n);   
    magacc(n) = sqrt(acc(n,1).^2 + acc(n,2).^2 + acc(n,3).^2);
    magvel(n) = sqrt(vel(n,1).^2 + vel(n,2).^2 + vel(n,3).^2);   
end
    
figure(251); plot(magacc);

