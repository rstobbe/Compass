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

t1 = Tsegs(2)/2;
acc(2,1) = 2*((KSA(3,1)-KSA(2,1)) - vel(2,1)*t1)/(t1^2);
acc(2,2) = 2*((KSA(3,2)-KSA(2,2)) - vel(2,2)*t1)/(t1^2);
acc(2,3) = 2*((KSA(3,3)-KSA(2,3)) - vel(2,3)*t1)/(t1^2);

search = 1;
for n = 3:length(KSA)
    %if show == 1
        figure(251); hold on; plot(vel(:,1),'b-'); plot(vel(:,2),'g-'); plot(vel(:,3),'r-'); xlim([0 n]);
        figure(252); hold on; plot(acc(:,1),'b-'); plot(acc(:,2),'g-'); plot(acc(:,3),'r-'); xlim([0 n]);
        figure(253); hold on; plot(KSA(:,1),'b-*'); plot(KSA(:,2),'g-*'); plot(KSA(:,3),'r-*'); xlim([0 n]);
    %end
    axtemp1 = 2*((KSA(n,1)-KSA(n-1,1)) - vel(n-1,1)*t1)/(t1^2);
    aytemp1 = 2*((KSA(n,2)-KSA(n-1,2)) - vel(n-1,2)*t1)/(t1^2);
    aztemp1 = 2*((KSA(n,3)-KSA(n-1,3)) - vel(n-1,3)*t1)/(t1^2);
    magatemp1 = sqrt(axtemp1^2 + aytemp1^2 + aztemp1^2); 
    m = 0;
    while search == 1
        if magatemp1 < AccProf(1) 
            t2 = 0.99*t1;
        elseif magatemp1 > AccProf(1)
            t2 = 1.01*t1;
        end        
        axtemp2 = 2*((KSA(n,1)-KSA((n-1),1)) - vel((n-1),1)*t2)/(t2^2);
        aytemp2 = 2*((KSA(n,2)-KSA((n-1),2)) - vel((n-1),2)*t2)/(t2^2);
        aztemp2 = 2*((KSA(n,3)-KSA((n-1),3)) - vel((n-1),3)*t2)/(t2^2);
        magatemp2 = sqrt(axtemp2^2 + aytemp2^2 + aztemp2^2);
        
        gTsegs = (magatemp2-magatemp1)/(t2-t1);    
        t1 = t1 + (AccProf(1) - magatemp1)/gTsegs;

        axtemp1 = 2*((KSA(n,1)-KSA((n-1),1)) - vel((n-1),1)*t1)/(t1^2);
        aytemp1 = 2*((KSA(n,2)-KSA((n-1),2)) - vel((n-1),2)*t1)/(t1^2);
        aztemp1 = 2*((KSA(n,3)-KSA((n-1),3)) - vel((n-1),3)*t1)/(t1^2);
        magatemp1 = sqrt(axtemp1^2 + aytemp1^2 + aztemp1^2);   
        if abs(1-magatemp1/AccProf(1)) < 0.01
            Tsegs(n) = t1;
            break
        end
        m = m+1;
        if m == 10
            n
            error();
        end
    end
    vel(n,1) = vel((n-1),1) + axtemp1*t1;
    vel(n,2) = vel((n-1),2) + aytemp1*t1;
    vel(n,3) = vel((n-1),3) + aztemp1*t1;
    acc(n,1) = axtemp1;
    acc(n,2) = aytemp1;
    acc(n,3) = aztemp1;
end