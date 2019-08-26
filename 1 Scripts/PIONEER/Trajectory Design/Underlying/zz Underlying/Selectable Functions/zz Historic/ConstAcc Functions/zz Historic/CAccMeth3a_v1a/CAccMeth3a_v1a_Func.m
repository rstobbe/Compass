%==================================================
% 
%==================================================

function [CACCM,err] = CAccMeth3a_v1a_Func(CACCM,INPUT)

Status2('busy','Constrain Acceleration',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
T = INPUT.TArr0;
kArr = INPUT.kArr;
ScaleAccProf = INPUT.ScaleAccProf;

%test = kArr(1,:);
maxJrk = 3e5;
maxJrk2 = 2e7;
maxAcc = 600000;

%---------------------------------------------
% Start
%---------------------------------------------
Tsamp(1) = 0;
Tsamp(2) = T(2);

CJrk = 0;
while true
    Vel(1,:) = kArr(2,:)/Tsamp(2);
    Tvel(1) = Tsamp(2)/2;
    Acc(1,:) = Vel(1,:)/(2*Tvel);               % (2x) assuming time projection negative
    Tacc(1) = Tvel(1)/2;
    Jrk(1,:) = Acc(1,:)/(4*Tacc);
    Tjrk(1) = Tacc(1)/2;

    mAcc(1) = sqrt(Acc(1,1)^2 + Acc(1,2)^2 + Acc(1,3)^2);
    mJrk(1) = sqrt(Jrk(1,1)^2 + Jrk(1,2)^2 + Jrk(1,3)^2);

    if CJrk == 0
        if mJrk(1) > maxJrk
            Tsamp(2) = Tsamp(2)*1.01;
            CJrk = 1;
        elseif mAcc(1) < maxAcc*0.99
            Tsamp(2) = Tsamp(2)*0.99;
        elseif mAcc(1) > maxAcc*1.01
            Tsamp(2) = Tsamp(2)*1.01;
        else 
            break
        end
    else
         if mJrk(1) > maxJrk
            Tsamp(2) = Tsamp(2)*1.01;
         elseif mJrk(1) < maxJrk
                break
         end
    end
    magJrk = mJrk(1);
end 

Tseg(1) = Tsamp(2);
K1start = 1;
K2start = 1;
Lvlstart = 1;
stepback = 1.05;
Cstrn = 'Jrk2';
CJrk2dir = 1;
CJrkdir = 1;
for n = 3:length(T)    
    N = 1;
    done = 0;
    doneJrk = 0;
    doneJrk2 = 0;
    L1 = 1;
    L2 = 1;
    K1 = K1start;
    K2 = K2start;
    Lvl = Lvlstart;
    TstmAcc = [];
    TstmJrk = [];
    TstTseg = [];    
    if n == 3
        Tseg(n-1) = Tseg(n-2)/stepback;
    else
        Tseg(n-1) = Tseg(n-2)/stepback;
    end
    while true
        Tsamp(n) = Tsamp(n-1)+Tseg(n-1);
        Vel(n-1,:) = (kArr(n,:)-kArr(n-1,:))/(Tseg(n-1));
        Tvel(n-1) = (Tsamp(n-1)+Tsamp(n))/2;
        Acc(n-1,:) = (Vel(n-1,:)-Vel(n-2,:))/(Tvel(n-1)-Tvel(n-2));
        Tacc(n-1) = (Tvel(n-1)+Tvel(n-2))/2;
        Jrk(n-1,:) = (Acc(n-1,:)-Acc(n-2,:))/(Tacc(n-1)-Tacc(n-2));
        Tjrk(n-1) = (Tacc(n-1)+Tacc(n-2))/2;
        Jrk2(n-1,:) = (Jrk(n-1,:)-Jrk(n-2,:))/(Tjrk(n-1)-Tjrk(n-2));
        Tjrk2(n-1) = (Tjrk(n-1)+Tjrk(n-2))/2;
        
        mVel(n-1) = sqrt(Vel(n-1,1)^2 + Vel(n-1,2)^2 + Vel(n-1,3)^2);
        mAcc(n-1) = sqrt(Acc(n-1,1)^2 + Acc(n-1,2)^2 + Acc(n-1,3)^2);
        mJrk(n-1) = sqrt(Jrk(n-1,1)^2 + Jrk(n-1,2)^2 + Jrk(n-1,3)^2);  
        mJrk2(n-1) = sqrt(Jrk2(n-1,1)^2 + Jrk2(n-1,2)^2 + Jrk2(n-1,3)^2); 
        
        TstTseg(N) = Tseg(n-1);
        TstmVel(N) = mVel(n-1);
        TstmAcc(N) = mAcc(n-1);
        TstmJrk(N) = mJrk(n-1);
        TstmJrk2(N) = mJrk2(n-1);        
        
        if done == 1
            Tsamp(n) = Tsamp(n-1)+Tseg(n-1);
            break
        end
        
        if strcmp(Cstrn,'Jrk') && doneJrk == 1 
            if mJrk2(n-1) > maxJrk2 && n > 10
                TstmAcc = [];
                TstmJrk = [];
                TstmJrk2 = [];
                TstTseg = [];   
                N = 0; 
                Cstrn = 'Jrk2';
            else
                done = 1;
            end
        end
        
        if mJrk(n-1) > maxJrk  && doneJrk ~= 1
            Cstrn = 'Jrk'; 
        elseif mAcc(n-1) > maxAcc
            Cstrn = 'Acc';
        end
            
        if strcmp(Cstrn,'Jrk2');
            if N > 2
                if TstmJrk2(N) > TstmJrk2(N-1)
                    CJrk2dir = CJrk2dir*-1;
                end
            end
            JrkAcc = 1.01;
            [Tseg,K1,K2,K1start,K2start,Lvlstart,stepback,Lvl,N,doneJrk2] = CJrkfunc(mJrk2,maxJrk2,Tseg,K1,K2,K1start,K2start,Lvlstart,stepback,Lvl,N,n,TstmJrk2,TstTseg,CJrk2dir,JrkAcc);
            if doneJrk2 == 1
                done = 1;
            end
        elseif strcmp(Cstrn,'Jrk') && doneJrk ~= 1
            JrkAcc = 1.000001;
            [Tseg,K1,K2,K1start,K2start,Lvlstart,stepback,Lvl,N,doneJrk] = CJrkfunc(mJrk,maxJrk,Tseg,K1,K2,K1start,K2start,Lvlstart,stepback,Lvl,N,n,TstmJrk,TstTseg,CJrkdir,JrkAcc);  
            if doneJrk == 1
                test = 0;
            end                
        end
        
        N = N+1;
    end
 
    %clf(figure(1)); hold on;
    %plot(Tsamp,ones(length(Tsamp)),'k*');
    %plot(Tvel,2*ones(length(Tvel)),'b*');    
    %plot(Tacc,3*ones(length(Tacc)),'r*');  
    %plot(Tacc,'-*');
    
    %clf(figure(4));
    %plot(TstTseg);    
    %clf(figure(5));
    %plot(TstmAcc);    
    %clf(figure(6));
    %plot(TstmJrk);    
    %clf(figure(9));
    %plot(mVel);   
    %clf(figure(12));
    %plot(Tseg);     
    %clf(figure(10));
    %plot(mAcc);
    %clf(figure(11));

    clf(figure(13));
    plot(Tsamp(1:n),kArr(1:n,:));
    clf(figure(14)); hold on;
    plot(Tvel,Vel);
    plot(Tvel,mVel,'k');
    clf(figure(15)); hold on;
    plot(Tacc,Acc);
    plot(Tacc,mAcc,'k');
    clf(figure(16)); hold on;
    plot(Tjrk,Jrk);
    plot(Tjrk,mJrk,'k');
    clf(figure(17)); hold on;
    plot(Tjrk2,Jrk2);
    plot(Tjrk2,mJrk2,'k');
end        

%---------------------------------------------
% Return
%---------------------------------------------
CACCM.TArr = T;
CACCM.Tsegs = Tsegs;

Status2('done','',3);


%==================================================
% 
%==================================================
function [Tseg,L1,L2] = CAcc(Tseg,L1,L2)

if mAcc(n-1) < maxAcc*0.999999
    if L2 == 1
        Tseg(n-1) = Tseg(n-1)*0.999;
        L1 = 1;
    elseif L2 == 2
        Tseg(n-1) = Tseg(n-1)*0.9999;
        L1 = 2;
    elseif L2 == 3
        Tseg(n-1) = Tseg(n-1)*0.99999;
        L1 = 3;
    elseif L2 == 4
        Tseg(n-1) = Tseg(n-1)*0.999999;
        L1 = 4;
    elseif L2 == 5
        Tseg(n-1) = Tseg(n-1)*0.9999999;
        L1 = 5;
    elseif L2 == 6
        Tseg(n-1) = Tseg(n-1)*0.99999999;
        L1 = 6;
    elseif L2 == 7
        Tseg(n-1) = Tseg(n-1)*0.999999999;
        L1 = 7;
    elseif L2 == 8
        Tseg(n-1) = Tseg(n-1)*0.9999999999;
        L1 = 8;
    end
elseif mAcc(n-1) > maxAcc*1.000001
    CAcc = 1;
    stepback = 1;
    if L1 == 1
        Tseg(n-1) = Tseg(n-1)*1.0001;
        L2 = 2;
    elseif L1 == 2
        Tseg(n-1) = Tseg(n-1)*1.00001;
        L2 = 3;
    elseif L1 == 3
        Tseg(n-1) = Tseg(n-1)*1.000001;
        L2 = 4;
    elseif L1 == 4
        Tseg(n-1) = Tseg(n-1)*1.0000001;
        L2 = 5;
    elseif L1 == 5
        Tseg(n-1) = Tseg(n-1)*1.00000001;
        L2 = 6;
    elseif L1 == 6
        Tseg(n-1) = Tseg(n-1)*1.000000001;
        L2 = 7;
    elseif L1 == 7
        Tseg(n-1) = Tseg(n-1)*1.0000000001;
        L2 = 8;
    elseif L1 == 8
        error();
    end
else
    %if mJrk(n-1) < maxJrk
        done = 1;
    %else
    %    error();
    %end 
end


%==================================================
% 
%==================================================
function [Tseg,K1,K2,K1start,K2start,Lvlstart,stepback,Lvl,N,done] = CJrkfunc(mJrk,maxJrk,Tseg,K1,K2,K1start,K2start,Lvlstart,stepback,Lvl,N,n,TstmJrk,TstTseg,CJrk2dir,Acc)

done = 0;
if N > 5000
    if Lvlstart == 1
        clf(figure(4));
        plot(TstTseg);      
        clf(figure(6));
        plot(TstmJrk); 
        ind = find(TstmJrk==min(TstmJrk));
        if ind == 1
            stepback = 2*(stepback-1)+1;
            Tseg(n-1) = Tseg(n-2)/stepback;
        elseif ind == 5001
            stepback = 0.5*(stepback-1)+1;
            Tseg(n-1) = Tseg(n-2)/stepback;  
        else     
            K1 = 2;
            K2 = 2;
            Lvl = 2;
            K1start = 2;
            K2start = 2;
            Lvlstart = 2 
            stepback = 0.5*(stepback-1)+1;
            Tseg(n-1) = Tseg(n-2)/stepback;  
        end  
    elseif Lvlstart == 2
        clf(figure(4));
        plot(TstTseg);      
        clf(figure(6));
        plot(TstmJrk); 
        ind = find(TstmJrk==min(TstmJrk));
        if ind == 1
            stepback = 2*(stepback-1)+1;
            Tseg(n-1) = Tseg(n-2)/stepback;
        elseif ind == 5001
            stepback = 0.5*(stepback-1)+1;
            Tseg(n-1) = Tseg(n-2)/stepback;  
        else      
            K1 = 3;
            K2 = 3;
            Lvl = 3;
            K1start = 3;
            K2start = 3;
            Lvlstart = 3 
            stepback = 0.5*(stepback-1)+1;
            Tseg(n-1) = Tseg(n-2)/stepback;  
        end  
    elseif Lvlstart == 3
        clf(figure(4));
        plot(TstTseg);      
        clf(figure(6));
        plot(TstmJrk); 
        ind = find(TstmJrk==min(TstmJrk));
        if ind == 1
            stepback = 2*(stepback-1)+1;
            Tseg(n-1) = Tseg(n-2)/stepback;
        elseif ind == 5001
            stepback = 0.5*(stepback-1)+1;
            Tseg(n-1) = Tseg(n-2)/stepback;  
        else      
            K1 = 4;
            K2 = 4;
            Lvl = 4;
            K1start = 4;
            K2start = 4;
            Lvlstart = 4
            stepback = 0.5*(stepback-1)+1;
            Tseg(n-1) = Tseg(n-2)/stepback;  
        end 
    elseif Lvlstart == 4
        clf(figure(4));
        plot(TstTseg);      
        clf(figure(6));
        plot(TstmJrk); 
        ind = find(TstmJrk==min(TstmJrk));
        if ind == 1
            stepback = 2*(stepback-1)+1;
            Tseg(n-1) = Tseg(n-2)/stepback;
        elseif ind == 5001
            stepback = 0.5*(stepback-1)+1;
            Tseg(n-1) = Tseg(n-2)/stepback;  
        else      
            K1 = 5;
            K2 = 5;
            Lvl = 5;
            K1start = 5;
            K2start = 5;
            Lvlstart = 5 
            stepback = 0.5*(stepback-1)+1;
            Tseg(n-1) = Tseg(n-2)/stepback;  
        end 
    elseif Lvlstart == 5
        clf(figure(4));
        plot(TstTseg);      
        clf(figure(6));
        plot(TstmJrk); 
        ind = find(TstmJrk==min(TstmJrk));
        if ind == 1
            stepback = 2*(stepback-1)+1;
            Tseg(n-1) = Tseg(n-2)/stepback;
        elseif ind == 5001
            stepback = 0.5*(stepback-1)+1;
            Tseg(n-1) = Tseg(n-2)/stepback;  
        else      
            K1 = 6;
            K2 = 6;
            Lvl = 6;
            K1start = 6;
            K2start = 6;
            Lvlstart = 6 
            stepback = 0.5*(stepback-1)+1;
            Tseg(n-1) = Tseg(n-2)/stepback;  
        end
    elseif Lvlstart == 6
        error();
        %clf(figure(4));
        %plot(TstTseg);    
        %clf(figure(5));
        %plot(TstmAcc);    
        %clf(figure(6));
        %plot(TstmJrk); 
        K1 = 7;
        K2 = 7;
        Lvl = 7;
        K1start = 7;
        K2start = 7;
        Lvlstart = 7; 
        stepback = 1.00001
        Tseg(n-1) = Tseg(n-2)/stepback;
    elseif Lvlstart == 7
        %clf(figure(4));
        %plot(TstTseg);    
        %clf(figure(5));
        %plot(TstmAcc);    
        %clf(figure(6));
        %plot(TstmJrk); 
        K1 = 8;
        K2 = 8;
        Lvl = 8;
        K1start = 8;
        K2start = 8;
        Lvlstart = 8; 
        stepback = 1.000001
        Tseg(n-1) = Tseg(n-2)/stepback;
    elseif Lvlstart == 8
        %clf(figure(4));
        %plot(TstTseg);    
        %clf(figure(5));
        %plot(TstmAcc);    
        %clf(figure(6));
        %plot(TstmJrk); 
        K1 = 9;
        K2 = 9;
        Lvl = 9;
        K1start = 9;
        K2start = 9;
        Lvlstart = 9; 
        stepback = 1.000001
        Tseg(n-1) = Tseg(n-2)/stepback;
    elseif Lvlstart == 9
        clf(figure(4));
        plot(TstTseg);    
        clf(figure(5));
        plot(TstmAcc);    
        clf(figure(6));
        plot(TstmJrk); 
        error();
    end                
    TstmAcc = [];
    TstmJrk = [];
    TstTseg = [];   
    N = 0; 
end
    
if (mJrk(n-1) < maxJrk/Acc && CJrk2dir > 0) || (mJrk(n-1) > maxJrk*Acc && CJrk2dir < 0)
    if K2 == 1
        Tseg(n-1) = Tseg(n-1)*0.999;
        K1 = 1;
    elseif K2 == 2
        Tseg(n-1) = Tseg(n-1)*0.9999;
        K1 = 2;
    elseif K2 == 3
        Tseg(n-1) = Tseg(n-1)*0.99999;
        K1 = 3;
    elseif K2 == 4
        Tseg(n-1) = Tseg(n-1)*0.999999;
        K1 = 4;
    elseif K2 == 5
        Tseg(n-1) = Tseg(n-1)*0.9999999;
        K1 = 5;
    elseif K2 == 6
        Tseg(n-1) = Tseg(n-1)*0.99999999;
        K1 = 6;
    elseif K2 == 7
        Tseg(n-1) = Tseg(n-1)*0.999999999;
        K1 = 7;
    elseif K2 == 8
        Tseg(n-1) = Tseg(n-1)*0.9999999999;
        K1 = 8;
    elseif K2 == 9
        Tseg(n-1) = Tseg(n-1)*0.99999999999;
        K1 = 9;
    elseif K2 == 10
        Tseg(n-1) = Tseg(n-1)*0.999999999999;
        K1 = 10;
    elseif K2 == 11
        Tseg(n-1) = Tseg(n-1)*0.9999999999999;
        K1 = 10;
    end
elseif (mJrk(n-1) > maxJrk*Acc && CJrk2dir > 0) || (mJrk(n-1) < maxJrk/Acc && CJrk2dir < 0)
    if K1 == 1
        Tseg(n-1) = Tseg(n-1)*1.0001;
        K2 = 2;
    elseif K1 == 2
        Tseg(n-1) = Tseg(n-1)*1.00001;
        K2 = 3;
    elseif K1 == 3
        Tseg(n-1) = Tseg(n-1)*1.000001;
        K2 = 4;
    elseif K1 == 4
        Tseg(n-1) = Tseg(n-1)*1.0000001;
        K2 = 5;
    elseif K1 == 5
        Tseg(n-1) = Tseg(n-1)*1.00000001;
        K2 = 6;
    elseif K1 == 6
        Tseg(n-1) = Tseg(n-1)*1.000000001;
        K2 = 7;
    elseif K1 == 7
        Tseg(n-1) = Tseg(n-1)*1.0000000001;
        K2 = 8;
    elseif K1 == 8
        Tseg(n-1) = Tseg(n-1)*1.00000000001;
        K2 = 9;
    elseif K1 == 9
        Tseg(n-1) = Tseg(n-1)*1.000000000001;
        K2 = 10;
    elseif K1 == 10
        Tseg(n-1) = Tseg(n-1)*1.0000000000001;
        K2 = 11;
    elseif K1 == 11
        error();
    end          
else
    if N > 200 && n > 5
        stepback = 0.8*(stepback-1)+1; 
    end        
    done = 1;
end
