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

test = kArr(1,:)
maxJrk = 3e5;
maxAcc = 6000;

Tsamp(1) = 0;
Tsamp(2) = T(2);

CJrk = 0;
while true
    Vel(1,:) = kArr(2,:)/Tsamp(2);
    Tvel(1) = T(2)/2;
    Acc(1,:) = Vel(1,:)/Tvel;
    Tacc(1) = Tvel(1)/2;
    Jrk(1,:) = Acc(1,:)/Tacc;
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
for n = 3:length(T)    
    CJrk = 1;
    CAcc = 0;
    N = 1;
    done = 0;
    L1 = 1;
    L2 = 1;
    K1 = K1start;
    K2 = K2start;
    Lvl = Lvlstart;
    TstmAcc = [];
    TstmJrk = [];
    TstTseg = [];    
    if n == 3
        Tseg(n-1) = Tseg(n-2)/4;
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

        mVel(n-1) = sqrt(Vel(n-1,1)^2 + Vel(n-1,2)^2 + Vel(n-1,3)^2);
        mAcc(n-1) = sqrt(Acc(n-1,1)^2 + Acc(n-1,2)^2 + Acc(n-1,3)^2);
        mJrk(n-1) = sqrt(Jrk(n-1,1)^2 + Jrk(n-1,2)^2 + Jrk(n-1,3)^2);  

        TstmAcc(N) = mAcc(n-1);
        TstmJrk(N) = mJrk(n-1);
        TstTseg(N) = Tseg(n-1);
        
        if done == 1
            Tsamp(n) = Tsamp(n-1)+Tseg(n-1);
            break
        end
        
        if CJrk == 0
            %if mJrk(n-1) > maxJrk  && CAcc == 0;
            if mJrk(n-1) > maxJrk && (mAcc(n-1) < maxAcc) 
                CJrk = 1;
            elseif mAcc(n-1) < maxAcc*0.9999
                CAcc = 1
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
            elseif mAcc(n-1) > maxAcc*1.0001
                CAcc = 1
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
        else
            %if (mAcc(n-1) > maxAcc) && (mJrk(n-1) < maxJrk)
            %    CJrk = 0;
            if N > 50000 && n > 20
                if Lvlstart == 1
                    K1 = 2;
                    K2 = 2;
                    Lvl = 2;
                    K1start = 2;
                    K2start = 2;
                    Lvlstart = 2;
                    stepback = 1.01
                    Tseg(n-1) = Tseg(n-2)/stepback;
                elseif Lvlstart == 2
                    K1 = 3;
                    K2 = 3;
                    Lvl = 3;
                    K1start = 3;
                    K2start = 3;
                    Lvlstart = 3; 
                    stepback = 1.0018
                    Tseg(n-1) = Tseg(n-2)/stepback;
                elseif Lvlstart == 3
                    K1 = 4;
                    K2 = 4;
                    Lvl = 4;
                    K1start = 4;
                    K2start = 4;
                    Lvlstart = 4; 
                    stepback = 1.0004
                    Tseg(n-1) = Tseg(n-2)/stepback;
                elseif Lvlstart == 4
                    clf(figure(4));
                    plot(TstTseg);    
                    clf(figure(5));
                    plot(TstmAcc);    
                    clf(figure(6));
                    plot(TstmJrk); 
                    ind = find(TstmJrk==min(TstmJrk))
                    if TstmJrk(ind-1) < TstmJrk(ind)*1.01 && TstmJrk(ind+1) < TstmJrk(ind)*1.01
                        Tseg(n-1) = TstTseg(ind);
                        done = 1;
                    else
                        if ind <50
                            stepback = stepback*2;
                        end
                        Tseg(n-1) = Tseg(n-2)/stepback;
                        K1 = 5;
                        K2 = 5;
                        Lvl = 5;
                        K1start = 5;
                        K2start = 5;
                        Lvlstart = 5; 
                    end
                elseif Lvlstart == 5
                    clf(figure(4));
                    plot(TstTseg);    
                    clf(figure(5));
                    plot(TstmAcc);    
                    clf(figure(6));
                    plot(TstmJrk); 
                    ind = find(TstmJrk==min(TstmJrk))
                    if TstmJrk(ind-1) < TstmJrk(ind)*1.01 && TstmJrk(ind+1) < TstmJrk(ind)*1.01
                        Tseg(n-1) = TstTseg(ind);
                        done = 1;
                    else
                        if ind <50
                            stepback = stepback*2;
                        end
                        Tseg(n-1) = Tseg(n-2)/stepback;
                        K1 = 6;
                        K2 = 6;
                        Lvl = 6;
                        K1start = 6;
                        K2start = 6;
                        Lvlstart = 6;                         
                    end
                elseif Lvlstart == 6
                    clf(figure(4));
                    plot(TstTseg);    
                    clf(figure(5));
                    plot(TstmAcc);    
                    clf(figure(6));
                    plot(TstmJrk); 
                    K1 = 7;
                    K2 = 7;
                    Lvl = 7;
                    K1start = 7;
                    K2start = 7;
                    Lvlstart = 7; 
                    stepback = 1.00001
                    Tseg(n-1) = Tseg(n-2)/stepback;
                elseif Lvlstart == 7
                    clf(figure(4));
                    plot(TstTseg);    
                    clf(figure(5));
                    plot(TstmAcc);    
                    clf(figure(6));
                    plot(TstmJrk); 
                    K1 = 8;
                    K2 = 8;
                    Lvl = 8;
                    K1start = 8;
                    K2start = 8;
                    Lvlstart = 8; 
                    stepback = 1.000001
                    Tseg(n-1) = Tseg(n-2)/stepback;
                elseif Lvlstart == 8
                    clf(figure(4));
                    plot(TstTseg);    
                    clf(figure(5));
                    plot(TstmAcc);    
                    clf(figure(6));
                    plot(TstmJrk); 
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
            elseif mJrk(n-1) < maxJrk*0.999999
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
                end
            elseif mJrk(n-1) > maxJrk*1.000001
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
                    error();
                end          
            else
                %if mAcc(n-1) < maxAcc
                    done = 1;
                %else
                %    error();
                %end 
            end
        end
        N = N+1;
    end
 
    clf(figure(4));
    plot(TstTseg);    
    clf(figure(5));
    plot(TstmAcc);    
    clf(figure(6));
    plot(TstmJrk);    
    %clf(figure(9));
    %plot(mVel);   
    clf(figure(12));
    plot(Tseg);     
    clf(figure(10));
    plot(mAcc);
    clf(figure(11));
    plot(mJrk);
    %clf(figure(13));
    %plot(Tsamp(1:n),kArr(1:n,:));
end        

%---------------------------------------------
% Constrain
%---------------------------------------------
Tsegs = zeros(1,length(T));
for n = 2:length(T)
    Tsegs(n) = sqrt(magacc(n)/ScaleAccProf(n-1))*(T(n)-T(n-1));
end

for n = 2:length(T)
    T(n) = T(n-1) + Tsegs(n);
end

%---------------------------------------------
% Return
%---------------------------------------------
CACCM.TArr = T;
CACCM.Tsegs = Tsegs;

Status2('done','',3);