%==================================================
% 
%==================================================

function [CACCM,err] = CAccMeth3b2D_v2b_Func(CACCM,INPUT)

Status2('busy','Constrain Acceleration',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
T = INPUT.TArr0;
kArr = INPUT.kArr;
maxJrk = CACCM.gacc*42.577;
maxAcc = CACCM.gvel*42.577;
GVP = CACCM.GVP;
clear INPUT

%---
Accuracy = 1.00001;
%---

%---------------------------------------------
% Get Acceleration Profile
%---------------------------------------------
radevfunc = str2func([CACCM.gvelprof,'_Func']);  
INPUT = struct();         
[GVP,err] = radevfunc(GVP,INPUT);
if err.flag == 1
    return
end
clear INPUT;
Accproffunc0 = str2func(GVP.Accprof);
Accproffunc0 = @(Acc0,t) Accproffunc0(Acc0,maxAcc,t);

%---------------------------------------------
% Constrain Initial Jerk
%---------------------------------------------
initJrk = 3e5;
while true;
    [Tsamp,Tvel,Vel,mVel,Tacc,Acc,mAcc,Tjrk,Jrk,mJrk] = CIJ(T,kArr,initJrk);
    Accproffunc = @(t) Accproffunc0(mAcc(1),t-Tacc(1));
    Tseg(1) = Tsamp(2);
    [Tseg,Tsamp,Tvel,Vel,mVel,Tacc,Acc,mAcc,Tjrk,Jrk,mJrk,~] = CAccTop(3,Accproffunc,Tseg,Tsamp,Tvel,Vel,mVel,Tacc,Acc,mAcc,Tjrk,Jrk,mJrk,kArr,Accuracy);
    if mJrk(1) > 0.25*mJrk(2)
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
    t = (0:0.001:1) + Tacc(1);
    figure(3020); hold on; 
    plot(t,Accproffunc(t),'k-','linewidth',2); 
    xlabel('ms'); ylabel('Acc Profile');
    button = questdlg('Continue');
    if strcmp(button,'No');
        return
    end
end

%---------------------------------------------
% Test first time segment
%---------------------------------------------


%---------------------------------------------
% Start Acceleration Constraint
%---------------------------------------------
Tseg(1) = Tsamp(2);
Ntotarr = zeros(size(T));
for n = 3:length(T)    
    [Tseg,Tsamp,Tvel,Vel,mVel,Tacc,Acc,mAcc,Tjrk,Jrk,mJrk,Nreturn] = CAccTop(n,Accproffunc,Tseg,Tsamp,Tvel,Vel,mVel,Tacc,Acc,mAcc,Tjrk,Jrk,mJrk,kArr,Accuracy);
    Ntotarr(n) = Nreturn;   
    if mJrk(end) > maxJrk
        clf(figure(13));
        plot(Tsamp);
        clf(figure(14)); hold on;
        plot(Tvel,Vel);
        plot(Tvel,mVel,'k');
        clf(figure(15)); hold on;
        plot(Tacc,Acc);
        plot(Tacc,mAcc,'k');
        clf(figure(16)); hold on;
        plot(Tjrk,Jrk);
        plot(Tjrk,mJrk,'k');
        err.flag = 1;
        err.msg = 'Alter ''GvelProf''';
        return
    end
    Status2('busy',['Along Trajectory: ',num2str(length(T)-n)],3);
end        


%---------------------------------------------
% Plot
%---------------------------------------------
clf(figure(15)); hold on;
plot(Tacc,Acc); plot(Tacc,mAcc,'k');
xlabel('ms'); ylabel('Acc');
title('Trajectory Acc');
clf(figure(16)); hold on;
plot(Tjrk,Jrk); plot(Tjrk,mJrk,'k');
xlabel('ms'); ylabel('Jerk');
title('Trajectory Jerk');

%---------------------------------------------
% Return
%---------------------------------------------
CACCM.TArr = Tsamp;
CACCM.relprojleninc = [];
Status2('done','',3);



%======================================================
% Constrain Initial Jerk
%======================================================
function [Tsamp,Tvel,Vel,mVel,Tacc,Acc,mAcc,Tjrk,Jrk,mJrk] = CIJ(T,kArr,initJrk)

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

    mVel(1) = sqrt(Vel(1,1)^2 + Vel(1,2)^2);
    mAcc(1) = sqrt(Acc(1,1)^2 + Acc(1,2)^2);
    mJrk(1) = sqrt(Jrk(1,1)^2 + Jrk(1,2)^2);

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



%=======================================================
% 
%=======================================================
function [Tseg,Tsamp,Tvel,Vel,mVel,Tacc,Acc,mAcc,Tjrk,Jrk,mJrk,Nreturn] = CAccTop(n,Accproffunc,Tseg,Tsamp,Tvel,Vel,mVel,Tacc,Acc,mAcc,Tjrk,Jrk,mJrk,kArr,Accuracy)
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
stepback = 1.05;
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

    mVel(n-1) = sqrt(Vel(n-1,1)^2 + Vel(n-1,2)^2);
    mAcc(n-1) = sqrt(Acc(n-1,1)^2 + Acc(n-1,2)^2);
    mJrk(n-1) = sqrt(Jrk(n-1,1)^2 + Jrk(n-1,2)^2);         

    TstTseg(N) = Tseg(n-1);
    TstmVel(N) = mVel(n-1);
    TstmAcc(N) = mAcc(n-1);
    TstmJrk(N) = mJrk(n-1);
    
    if done == 1
        maxAcc = Accproffunc(Tacc(n-1));     
        if maxAcc < maxAcc0*Accuracy && maxAcc > maxAcc0/Accuracy
            Tsamp(n) = Tsamp(n-1)+Tseg(n-1);
            break
        end
        if N > Nreturn
            Nreturn = Nreturn + N;
        end
        TstmAcc = [];
        TstmJrk = [];
        TstTseg = []; 
        Ntest = 0;
        N = 1;
        L1 = L1start;
        L2 = L1start;
        Lvl = Lvlstart;
        maxAcc0 = maxAcc;
    end            

    [Tseg,L1,L2,L1start,L2start,Lvlstart,stepback,Lvl,N,done] = CAccfunc(mAcc,maxAcc,Tseg,L1,L2,L1start,L2start,Lvlstart,stepback,Lvl,N,n,TstmAcc,TstTseg,1,Accuracy); 
    if Lvlstart == 2 && done ~= 1
        error();                % finish
        maxAcc = min(TstmAcc)*1.000001;
        Lvlstart = 1;
    end
    if N == 0
        error();                % finish
        Ntest = Ntest+1;
    end
    if Ntest > 10
        error();              
    end      
    N = N+1;
end


%==================================================
% 
%==================================================
function [Tseg,K1,K2,K1start,K2start,Lvlstart,stepback,Lvl,N,done] = CAccfunc(mAcc,maxAcc,Tseg,K1,K2,K1start,K2start,Lvlstart,stepback,Lvl,N,n,TstmAcc,TstTseg,CAccdir,Accuracy)

Nmax = 5000;
done = 0;
if N > Nmax
    error();
    if Lvlstart == 1
        clf(figure(6));
        plot(TstmAcc); 
        ind = find(TstmAcc==min(TstmAcc));
        if ind == 1
            stepback = 1.1*stepback;
            Tseg(n-1) = Tseg(n-2)/stepback;
        elseif ind == Nmax + 1
            stepback = 0.9*stepback;
            Tseg(n-1) = Tseg(n-2)/stepback;  
        else
            K1 = 2;
            K2 = 2;
            Lvl = 2;
            K1start = 2;
            K2start = 2;
            stepback = 1.1*stepback; 
            Lvlstart = 2; 
            Tseg(n-1) = Tseg(n-2)/stepback;
        end 
    elseif Lvlstart == 2
        %clf(figure(6));
        %plot(TstmAcc); 
        ind = find(TstmAcc==min(TstmAcc));
        if ind == 1
            stepback = 1.05*stepback;
            Tseg(n-1) = Tseg(n-2)/stepback;
        elseif ind == Nmax + 1
            stepback = 0.95*stepback;
            Tseg(n-1) = Tseg(n-2)/stepback;  
        else      
            K1 = 3;
            K2 = 3;
            Lvl = 3;
            K1start = 3;
            K2start = 3;
            Lvlstart = 3; 
            stepback = 1.1*stepback;
            Tseg(n-1) = Tseg(n-2)/stepback;  
        end  
    elseif Lvlstart == 3
        %clf(figure(6));
        %plot(TstmAcc);
        ind = find(TstmAcc==min(TstmAcc));
        if ind == 1
            %stepback = 1.05*stepback;
            stepback = 1.01*stepback;
            Tseg(n-1) = Tseg(n-2)/stepback;
        elseif ind == Nmax + 1
            %stepback = 0.95*stepback;
            stepback = 0.99*stepback;
            Tseg(n-1) = Tseg(n-2)/stepback;  
        else      
            K1 = 4;
            K2 = 4;
            Lvl = 4;
            K1start = 4;
            K2start = 4;
            Lvlstart = 4;
            stepback = 1.05*stepback;
            Tseg(n-1) = Tseg(n-2)/stepback;  
        end 
    elseif Lvlstart == 4
        %clf(figure(6));
        %plot(TstmAcc);
        ind = find(TstmAcc==min(TstmAcc));
        if ind == 1
            %stepback = 1.05*stepback;
            stepback = 1.001*stepback;
            Tseg(n-1) = Tseg(n-2)/stepback;
        elseif ind == Nmax + 1
            %stepback = 0.95*stepback;
            stepback = 0.999*stepback;
            Tseg(n-1) = Tseg(n-2)/stepback;  
        else
            clf(figure(6));
            plot(TstmAcc);
            error();        % can't make the corner
%             K1 = 5;
%             K2 = 5;
%             Lvl = 5;
%             K1start = 5;
%             K2start = 5;
%             Lvlstart = 5;
%             stepback = 1.1*stepback;
%             Tseg(n-1) = Tseg(n-2)/stepback;  
        end 
%     elseif Lvlstart == 5
%         ind = find(TstmAcc==min(TstmAcc));
%         if ind == 1
%             stepback = 1.05*stepback;
%             Tseg(n-1) = Tseg(n-2)/stepback;
%         elseif ind == Nmax + 1
%             stepback = 0.95*stepback;
%             Tseg(n-1) = Tseg(n-2)/stepback;  
%         else      
%             K1 = 6;
%             K2 = 6;
%             Lvl = 6;
%             K1start = 6;
%             K2start = 6;
%             Lvlstart = 6;
%             stepback = 1.1*stepback;
%             Tseg(n-1) = Tseg(n-2)/stepback;  
%         end 
%     elseif Lvlstart == 6
%         error();
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
    if N > 500 && n > 5
        if CAccdir > 0
            %stepback = 0.8*(stepback-1)+1; 
            stepback = 0.99*stepback;
        elseif CAccdir < 0
            %stepback = 1.2*(stepback-1)+1;
            stepback = 1.01*stepback;
        end
    elseif N > 200 && n > 5
        if CAccdir > 0
            %stepback = 0.8*(stepback-1)+1; 
            stepback = 0.995*stepback;
        elseif CAccdir < 0
            %stepback = 1.2*(stepback-1)+1;
            stepback = 1.005*stepback;
        end
    elseif N > 100 && n > 5        
        if CAccdir > 0
            %stepback = 0.8*(stepback-1)+1; 
            stepback = 0.998*stepback;
        elseif CAccdir < 0
            %stepback = 1.2*(stepback-1)+1;
            stepback = 1.002*stepback;
        end
    elseif N > 50 && n > 5        
        if CAccdir > 0
            %stepback = 0.8*(stepback-1)+1; 
            stepback = 0.999*stepback;
        elseif CAccdir < 0
            %stepback = 1.2*(stepback-1)+1;
            stepback = 1.001*stepback;
        end        
    end
    done = 1;
end
