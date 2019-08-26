%==================================================
% 
%==================================================

function [CACC,err] = ConstEvol_v4d_Func(CACC,INPUT)

Status2('busy','Constrain Trajectory Evolution',2);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
T = INPUT.TArr;
kArr = INPUT.kArr;
GVP = CACC.GVP;
type = INPUT.type;
PROJdgn = INPUT.PROJdgn;
maxJrk = CACC.gacc*42.577;
%maxAcc = CACC.gvel*42.577;
maxAcc = PROJdgn.maxaveacc;
clear INPUT

%---
Accuracy = 1.000001;
%---

%---------------------------------------------
% ConstEvol Things;
%---------------------------------------------
kArr = kArr * PROJdgn.kmax;
tro = PROJdgn.tro;

%---------------------------------------------
% Get Acceleration Profile
%---------------------------------------------
radevfunc = str2func([CACC.gvelprof,'_Func']);  
INPUT = struct();         
[GVP,err] = radevfunc(GVP,INPUT);
if err.flag == 1
    return
end
clear INPUT;
Accproffunc0 = str2func(GVP.Accprof);
Accproffunc0 = @(Acc0,t) Accproffunc0(Acc0,maxAcc,t/tro);

%---------------------------------------------
% SAFE
%---------------------------------------------
SAFE.magFR = [0.9999 0.9999 0.9999];
SAFE.tcFR = [0.00003 0.00003 0.00003];
SAFE.NfiltsFR = 1;
SAFE.magRF = [0.0001 0.0001 0.0001];
SAFE.tcRF = [20 20 20];
 
%---------------------------------------------
% Constrain Initial Jerk
%---------------------------------------------
initJrk = maxJrk;
stepback = 1.05;
while true;
    [Tsamp,Tvel,Vel,mVel,Tacc,Acc,mAcc,Tjrk,Jrk,mJrk,SAFE] = CIJ(T,kArr,initJrk,type,SAFE);
    Accproffunc = @(t) Accproffunc0(mAcc(1),t-Tacc(1));
    Tseg(1) = Tsamp(2);
    [Tseg,Tsamp,Tvel,Vel,mVel,Tacc,Acc,mAcc,Tjrk,Jrk,mJrk,stepback,~,SAFE] = CAccTop(3,Accproffunc,Tseg,Tsamp,Tvel,Vel,mVel,Tacc,Acc,mAcc,Tjrk,Jrk,mJrk,kArr,Accuracy,stepback,type,SAFE);
    if mJrk(1) > mJrk(2)
        initJrk = 0.9*mJrk(1);
    else
        break
    end
end

%------------------------------------------
% Visuals
%------------------------------------------
Vis = 'Yes';
if strcmp(Vis,'Yes') 
    t = (0:0.001:tro) + Tacc(1);
    figure(3020); hold on; 
    plot(t,Accproffunc(t)/max(Accproffunc(t)),'k-','linewidth',2); 
    xlabel('ms'); ylabel('Acc Profile');
    button = questdlg('Continue');
    if strcmp(button,'No');
        err.flag = 1;
        err.msg = 'aborted';
        return
    end
end

%---------------------------------------------
% Start Acceleration Constraint
%---------------------------------------------
maxNreturn = 0;
Tseg(1) = Tsamp(2);
Ntotarr = zeros(size(T));
stepback = 1.05;
for n = 3:length(T)    
    [Tseg,Tsamp,Tvel,Vel,mVel,Tacc,Acc,mAcc,Tjrk,Jrk,mJrk,stepback,Nreturn,SAFE] = CAccTop(n,Accproffunc,Tseg,Tsamp,Tvel,Vel,mVel,Tacc,Acc,mAcc,Tjrk,Jrk,mJrk,kArr,Accuracy,stepback,type,SAFE);
    Ntotarr(n) = Nreturn;   
    if Nreturn > maxNreturn
        maxNreturn = Nreturn;
    end
    if rem(n,100) == 0
        clf(figure(14)); hold on;
        plot(Tacc,SAFE.stim/maxAcc);
        plot(Tacc,((1*SAFE.stim(:,1).^2 + 2*SAFE.stim(:,2).^2 + 1.2*SAFE.stim(:,3).^2).^0.5)/maxAcc,'k');
        %plot(Tacc,((1*SAFE.stim(:,1).^2 + 1*SAFE.stim(:,2).^2 + 1*SAFE.stim(:,3).^2).^0.5)/maxAcc,'k');
        title('SAFE'); xlabel('ms'); ylabel('arb');
        clf(figure(15));
        %plot(Tacc,Acc/maxAcc);
        plot(Tacc,mAcc/maxAcc,'k');
        title('Relative Gradient Velocity'); xlabel('ms');
        clf(figure(16));
        %plot(Tjrk,Jrk/42.577);
        plot(Tjrk,mJrk/42.577,'k');
        title('Gradient Acceleration'); xlabel('ms'); ylabel('mT/m/ms2');
        %clf(figure(17));
        %plot(Tseg,'k');
        %title('Timing Segments'); ylabel('ms');
    end    
    if mJrk(end) > maxJrk
        clf(figure(15));
        plot(Tacc,Acc/maxAcc);
        plot(Tacc,mAcc/maxAcc,'k');
        title('Relative Gradient Velocity'); xlabel('ms');
        clf(figure(16));
        plot(Tjrk,Jrk/42.577);
        plot(Tjrk,mJrk/42.577,'k');
        title('Gradient Acceleration'); xlabel('ms'); ylabel('mT/m/ms2');
        err.flag = 1;
        err.msg = 'Alter ''GvelProf'' (Acceleration too large)';
        return
    end
    Status2('busy',['Along Trajectory: ',num2str(length(T)-n)],3);
end         

%---------------------------------------------
% Return
%---------------------------------------------
Tsamp = tro*Tsamp/Tsamp(length(Tsamp));
CACC.TArr = Tsamp;
CACC.relprojleninc = [];
Status2('done','',3);


%=======================================================
% TOP
%=======================================================
function [Tseg,Tsamp,Tvel,Vel,mVel,Tacc,Acc,mAcc,Tjrk,Jrk,mJrk,stepback,Nreturn,SAFE] = CAccTop(n,Accproffunc,Tseg,Tsamp,Tvel,Vel,mVel,Tacc,Acc,mAcc,Tjrk,Jrk,mJrk,kArr,Accuracy,stepback,type,SAFE)

TstmAcc = [];
TstmJrk = [];
TstTseg = []; 
Ntest = 0;
N = 1;
Nreturn = 0;
done = 0;
L1 = 1;
L2 = 1;
Lvl = 1;
Lvlstart = 1;
L1start = 1;
L2start = 1;
maxAcc = Accproffunc(Tacc(n-2));  
maxAcc0 = 0;
Tseg(n-1) = Tseg(n-2)/stepback;
while true
    Tsamp(n) = Tsamp(n-1)+Tseg(n-1);
    Vel(n-1,:) = (kArr(n,:)-kArr(n-1,:))/(Tseg(n-1));
    Tvel(n-1) = (Tsamp(n-1)+Tsamp(n))/2;
    Acc(n-1,:) = (Vel(n-1,:)-Vel(n-2,:))/(Tvel(n-1)-Tvel(n-2));
    Tacc(n-1) = (Tvel(n-1)+Tvel(n-2))/2;
    Jrk(n-1,:) = (Acc(n-1,:)-Acc(n-2,:))/(Tacc(n-1)-Tacc(n-2));
    Tjrk(n-1) = (Tacc(n-1)+Tacc(n-2))/2;

    for i = 1:SAFE.NfiltsFR
        SAFE.FR(n-1,:,i) = SAFE.magFR(:,i).*Acc(n-1,:) + SAFE.FR(n-2,:,i).*exp(-(Tacc(n-1)-Tacc(n-2))./SAFE.tcFR(:,i));
    end    
    SAFE.RF(n-1,:) = SAFE.magRF.*abs(Acc(n-1,:)) + SAFE.RF(n-2,:).*exp(-(Tacc(n-1)-Tacc(n-2))./SAFE.tcRF);
    SAFE.stim(n-1,:) = sum(abs(SAFE.FR(n-1,:,:)),3)+SAFE.RF(n-1,:);    
    
    if strcmp(type,'2D')
        mVel(n-1) = sqrt(Vel(n-1,1)^2 + Vel(n-1,2)^2);
        mAcc(n-1) = sqrt(Acc(n-1,1)^2 + Acc(n-1,2)^2);
        mJrk(n-1) = sqrt(Jrk(n-1,1)^2 + Jrk(n-1,2)^2);         
    elseif strcmp(type,'3D')
        mVel(n-1) = sqrt(Vel(n-1,1)^2 + Vel(n-1,2)^2 + Vel(n-1,3)^2);
        mAcc(n-1) = sqrt(Acc(n-1,1)^2 + Acc(n-1,2)^2 + Acc(n-1,3)^2);
        mJrk(n-1) = sqrt(Jrk(n-1,1)^2 + Jrk(n-1,2)^2 + Jrk(n-1,3)^2);
    end
        
    TstTseg(N) = Tseg(n-1);
    TstmVel(N) = mVel(n-1);
    TstmAcc(N) = mAcc(n-1);
    TstmJrk(N) = mJrk(n-1);
    
    if done == 1
        maxAcc = Accproffunc(Tacc(n-1));     
        if maxAcc < maxAcc0*Accuracy && maxAcc > maxAcc0/Accuracy  
            %clf(figure(7));
            %plot(TstmAcc);   
            Tsamp(n) = Tsamp(n-1)+Tseg(n-1);
            break
        end
        if N > Nreturn
            Nreturn = Nreturn + N;
        end
        %clf(figure(6));
        %plot(TstmAcc);           
        TstTseg = Tseg(n-1);
        TstmVel = mVel(n-1);
        TstmAcc = mAcc(n-1);
        TstmJrk = mJrk(n-1);
        Ntest = 0;
        N = 1;
        L1 = L1start;
        L2 = L1start;
        Lvl = Lvlstart;
        maxAcc0 = maxAcc;
    end            

    [Tseg,L1,L2,L1start,L2start,Lvlstart,stepback,Lvl,N,done] = CAccfunc(mAcc,maxAcc,Tseg,L1,L2,L1start,L2start,Lvlstart,stepback,Lvl,N,n,TstmAcc,TstTseg,1,Accuracy); 
    if Lvlstart == 3 && done ~= 1
        maxAcc = min(TstmAcc)*1.0000001;
        Lvlstart = 1;
    end
    if N == 0
        TstTseg = Tseg(n-1);
        TstmVel = mVel(n-1);
        TstmAcc = mAcc(n-1);
        TstmJrk = mJrk(n-1);
        Ntest = Ntest+1;
    end
    if Ntest > 10
        %Ntest = Ntest 
        %error();              
    end      
    N = N+1;
end


%==================================================
% FUNC
%==================================================
function [Tseg,K1,K2,K1start,K2start,Lvlstart,stepback,Lvl,N,done] = CAccfunc(mAcc,maxAcc,Tseg,K1,K2,K1start,K2start,Lvlstart,stepback,Lvl,N,n,TstmAcc,TstTseg,CAccdir,Accuracy)

if n > 5
    %Nmax = 1000;
    Nmax = 125;    
else
    Nmax = 5000;
end
done = 0;
if N > Nmax
    if Lvlstart == 1
        %clf(figure(9));
        %plot(TstmAcc); 
        ind = find(TstmAcc==min(TstmAcc));
        if ind == 1
            stepback = 1.001*stepback;
            Tseg(n-1) = Tseg(n-2)/stepback;
        elseif ind == Nmax + 1
            stepback = 0.999*stepback;
            Tseg(n-1) = Tseg(n-2)/stepback;  
        else
            K1 = 2;
            K2 = 2;
            Lvl = 2;
            K1start = 2;
            K2start = 2;
            stepback = 1.001*stepback; 
            Lvlstart = 2; 
            Tseg(n-1) = Tseg(n-2)/stepback;
        end 
    elseif Lvlstart == 2
        %clf(figure(10));
        %plot(TstmAcc); 
        ind = find(TstmAcc==min(TstmAcc));
        if ind == 1
            stepback = 1.001*stepback;
            Tseg(n-1) = Tseg(n-2)/stepback;
        elseif ind == Nmax + 1
            stepback = 0.999*stepback;
            Tseg(n-1) = Tseg(n-2)/stepback;  
        else
            Lvlstart = 3;                           % if Lvlstart == 3 -> can't make corner, allow flexibility (up above)
        end  
    end                
    N = 0; 
    
elseif (mAcc(n-1) < maxAcc/Accuracy && CAccdir > 0) || (mAcc(n-1) > maxAcc*Accuracy && CAccdir < 0)
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
elseif (mAcc(n-1) > maxAcc*Accuracy && CAccdir > 0) || (mAcc(n-1) < maxAcc/Accuracy && CAccdir < 0)
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
    if N > 100 && n > 5        
        %SB = 100
        if CAccdir > 0
            stepback = 0.999*stepback;
        elseif CAccdir < 0
            stepback = 1.001*stepback;
        end
    elseif N > 60 && n > 5        
        %SB = 60
        if CAccdir > 0
            stepback = 0.9999*stepback;
        elseif CAccdir < 0
            stepback = 1.0001*stepback;
        end
    elseif N > 50 && n > 5        
        %SB = 50
        if CAccdir > 0
            stepback = 0.99999*stepback;
        elseif CAccdir < 0
            stepback = 1.00001*stepback;
        end            
    end
    done = 1;
end

%======================================================
% Constrain Initial Jerk
%======================================================
function [Tsamp,Tvel,Vel,mVel,Tacc,Acc,mAcc,Tjrk,Jrk,mJrk,SAFE] = CIJ(T,kArr,initJrk,type,SAFE)

Tsamp(1) = 0;
Tsamp(2) = T(2);

N = 0;
while true
    Vel(1,:) = kArr(2,:)/Tsamp(2);
    Tvel(1) = Tsamp(2)/2;
    Acc(1,:) = Vel(1,:)/(2*Tvel);               % (2x) assuming time projection negative
    Tacc(1) = Tvel(1)/2;
    Jrk(1,:) = Acc(1,:)/(4*Tacc);
    Tjrk(1) = Tacc(1)/2;

    for i = 1:SAFE.NfiltsFR
        SAFE.FR(1,:,i) = Acc(1,:).*SAFE.magFR(:,i); 
    end
    SAFE.RF(1,:) = abs(Acc(1,:)).*SAFE.magRF; 
    SAFE.stim(1,:) = sum(abs(SAFE.FR(1,:,:)),3)+SAFE.RF(1,:); 
     
    if strcmp(type,'2D')
        mVel(1) = sqrt(Vel(1,1)^2 + Vel(1,2)^2);
        mAcc(1) = sqrt(Acc(1,1)^2 + Acc(1,2)^2);
        mJrk(1) = sqrt(Jrk(1,1)^2 + Jrk(1,2)^2);
    elseif strcmp(type,'3D')
        mVel(1) = sqrt(Vel(1,1)^2 + Vel(1,2)^2 + Vel(1,3)^2);
        mAcc(1) = sqrt(Acc(1,1)^2 + Acc(1,2)^2 + Acc(1,3)^2);
        mJrk(1) = sqrt(Jrk(1,1)^2 + Jrk(1,2)^2 + Jrk(1,3)^2);
    end
        
    if mJrk(1) > initJrk*1.01
        Tsamp(2) = Tsamp(2)*1.001;
    elseif mJrk(1) < initJrk*0.99
        Tsamp(2) = Tsamp(2)*0.999;
    else
        break
    end
    N = N+1;
    if N > 1e4
        error();
    end
end 