%==================================================
% Constrain Acceleration
% - gradient search version
%==================================================

function [Tsegs,vel,acc] = ConstAcc_v1(KSA,AccProf)

Tsegs = zeros(length(KSA),1);
vel = zeros(size(KSA));
acc = zeros(size(KSA));

Tsegs(2) = sqrt(2*sqrt(KSA(2,1).^2 + KSA(2,2).^2 + KSA(2,3).^2)/AccProf(1));            %length of first seg...
vel(2,1) = 2*KSA(2,1)/Tsegs(2);
vel(2,2) = 2*KSA(2,2)/Tsegs(2);
vel(2,3) = 2*KSA(2,3)/Tsegs(2); 

acc(2,1) = 2*KSA(2,1)/(Tsegs(2)^2);
acc(2,2) = 2*KSA(2,2)/(Tsegs(2)^2);
acc(2,3) = 2*KSA(2,3)/(Tsegs(2)^2);

search = 1;
for n = 3:length(KSA)
    
    if n == 102
        here = 1;
    end
    
    tx = (KSA(n,1)-KSA(n-1,1))/vel(n-1,1);
    ty = (KSA(n,2)-KSA(n-1,2))/vel(n-1,2);
    tz = (KSA(n,3)-KSA(n-1,3))/vel(n-1,3);
    t0 = min([abs(tx) abs(ty) abs(tz)]); 
    t1 = t0;

    axtemp1 = 2*((KSA(n,1)-KSA(n-1,1)) - vel(n-1,1)*t1)/(t1^2);
    aytemp1 = 2*((KSA(n,2)-KSA(n-1,2)) - vel(n-1,2)*t1)/(t1^2);
    aztemp1 = 2*((KSA(n,3)-KSA(n-1,3)) - vel(n-1,3)*t1)/(t1^2);
    magatemp0 = sqrt(axtemp1^2 + aytemp1^2 + aztemp1^2); 
    magatemp1 = magatemp0;
    m = 0;
    if (magatemp1 > 2*AccProf(1))
        here = 1;
    end
    while search == 1
        if magatemp1 < AccProf(1) 
            t2 = 0.9999*t1;
        elseif magatemp1 > AccProf(1)
            t2 = 1.0001*t1;
        end        
        axtemp2 = 2*((KSA(n,1)-KSA(n-1,1)) - vel(n-1,1)*t2)/(t2^2);
        aytemp2 = 2*((KSA(n,2)-KSA(n-1,2)) - vel(n-1,2)*t2)/(t2^2);
        aztemp2 = 2*((KSA(n,3)-KSA(n-1,3)) - vel(n-1,3)*t2)/(t2^2);
        magatemp2 = sqrt(axtemp2^2 + aytemp2^2 + aztemp2^2);

        gTsegs = (magatemp2-magatemp1)/(t2-t1);
        t1 = t1 + (AccProf(1) - magatemp1)/gTsegs

        axtemp1 = 2*((KSA(n,1)-KSA(n-1,1)) - vel(n-1,1)*t1)/(t1^2);
        aytemp1 = 2*((KSA(n,2)-KSA(n-1,2)) - vel(n-1,2)*t1)/(t1^2);
        aztemp1 = 2*((KSA(n,3)-KSA(n-1,3)) - vel(n-1,3)*t1)/(t1^2);
        magatemp1 = sqrt(axtemp1^2 + aytemp1^2 + aztemp1^2);   
        if abs(1-magatemp1/AccProf(1)) < 0.01
            break
        end
        m = m+1;
        if m == 100
            Tsegs(1:n)
            n
            figure(251); hold on; plot(vel(:,1),'b-'); plot(vel(:,2),'g-'); plot(vel(:,3),'r-'); xlim([0 n-1]);
            figure(252); hold on; plot(acc(:,1),'b-'); plot(acc(:,2),'g-'); plot(acc(:,3),'r-'); xlim([0 n-1]);
            error();
        end
    end
    if t1 < t0
        Tsegs(n) = t1;
        acc(n,1) = axtemp1;
        acc(n,2) = aytemp1;
        acc(n,3) = aztemp1;
    elseif t1 > t0 && (magatemp0 > AccProf(1)) 
        Tsegs(n) = t1;
        acc(n,1) = axtemp1;
        acc(n,2) = aytemp1;
        acc(n,3) = aztemp1;
    elseif t1 > t0 && (magatemp0 < AccProf(1)) 
        Tsegs(n) = t0;
        t1 = t0;
        acc(n,1) = 2*((KSA(n,1)-KSA(n-1,1)) - vel(n-1,1)*t1)/(t1^2);
        acc(n,2) = 2*((KSA(n,2)-KSA(n-1,2)) - vel(n-1,2)*t1)/(t1^2);
        acc(n,3) = 2*((KSA(n,3)-KSA(n-1,3)) - vel(n-1,3)*t1)/(t1^2);
    end
    vel(n,1) = vel(n-1,1) + acc(n,1)*t1;
    vel(n,2) = vel(n-1,2) + acc(n,2)*t1;
    vel(n,3) = vel(n-1,3) + acc(n,3)*t1;

    %figure(251); hold on; plot(vel(:,1),'b-'); plot(vel(:,2),'g-'); plot(vel(:,3),'r-'); xlim([0 n-1]);
    %figure(252); hold on; plot(acc(:,1),'b-'); plot(acc(:,2),'g-'); plot(acc(:,3),'r-'); xlim([0 n-1]);
    %figure(253); hold on; plot(KSA(:,1),'b-*'); plot(KSA(:,2),'g-*'); plot(KSA(:,3),'r-*'); xlim([0 n]);
    
end