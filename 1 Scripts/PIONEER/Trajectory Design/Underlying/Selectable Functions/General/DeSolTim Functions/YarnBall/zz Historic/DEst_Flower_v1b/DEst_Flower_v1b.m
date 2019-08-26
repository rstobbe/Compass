%====================================================
% (1b)
%   - just added 'visuals' selection to script
%====================================================

function [RADEVFUN,p,tau1,tau2,plin] = DEst_Flower_v1b(PROJipt,DEST)

%**********
p = 0.030;  
%**********

radevfun = PROJipt(strcmp('RadEv',{PROJipt.labelstr})).entrystr;
fineness = (PROJipt(strcmp('Fineness',{PROJipt.labelstr})).entrystr);
if iscell(fineness)
    fineness = PROJipt(strcmp('Fineness',{PROJipt.labelstr})).entrystr{PROJipt(strcmp('Fineness',{PROJipt.labelstr})).entryvalue};
end
fineness = str2double(fineness);
DESTVis = PROJipt(strcmp('DeSolTim Vis',{PROJipt.labelstr})).entrystr;
if iscell(DESTVis)
    DESTVis = PROJipt(strcmp('DeSolTim Vis',{PROJipt.labelstr})).entrystr{PROJipt(strcmp('DeSolTim Vis',{PROJipt.labelstr})).entryvalue};
end

%------------------------------------------
% Radial evolution function for solution timing
%------------------------------------------
func = str2func(radevfun);           
RADEVFUN = func(PROJipt,p);

%------------------------------------------
% Visuals
%------------------------------------------
if strcmp(DESTVis,'Yes') 
    r = (0:0.01:1);
    figure(90); hold on; plot(r,RADEVFUN(r),'k-','linewidth',2); xlabel('Relative Radial Value'); ylabel('Radial Evolution Value for Solution Generation');
end

%------------------------------------------
% Calculate Projection Lengths
%------------------------------------------
Status2('busy','Calculate Trajectory Lengths',2);
[plout,error0,errorflag] = LR1_ProjLenOutside_v1a(p,RADEVFUN);                    
if errorflag == 1
    error.string = error0;
    error.inputno = 0;
    return
end
plin = LR1_ProjLenInside_v1a(p,RADEVFUN);     

%------------------------------------------
% Create Timing Arrays for Solving
%------------------------------------------
Status2('busy','Create Timing Vector',2);
initstrght = DEST.initstrght;
if fineness == 1
    S = 0.06;                                       % slope 
    D = 4000;                                       % shape
    T = 0.0002510;                                  % shape
elseif fineness == 2
    S = 0.03;
    D = 4000;
    T = 0.0002510;  
elseif fineness == 3
    S = 0.020;
    D = 4000;
    T = 0.0002510; 
elseif fineness == 4
    S = 0.015;
    D = 4000;
    T = 0.0002515;                                  
elseif fineness == 5
    S = 0.010;
    D = 4000;
    T = 0.000252;                                  
elseif fineness == 6
    S = 0.005;
    D = 4000;
    T = 0.000254;                                  
elseif fineness == 7
    S = 0.0025;
    D = 4000;
    T = 0.000255;                                  
elseif fineness == 8
    S = 0.001;
    D = 4000;
    T = 0.00027;                                  
end
tMax = 300000;                                       % doesn't really matter just set sufficiently big
t = (0:tMax);                                    
if strcmp(initstrght,'Yes')
    tau1 = 0;
    tau = S*D*exp(-T*t)+(S*(t-D));
    test = tau(2) - tau(1);
    while test < 0
        T = T*0.9999;
        tau = ((S*D)-(plin))*(exp(-T*t))+(S*(t-D));          
        test = tau(2) - tau(1);
    end
    tau = tau - tau(1);
    SlvInd2 = find(tau <= plout,1,'last');
    tau2 = tau(1:SlvInd2);
else
    tau = ((S*D)-(plin))*(exp(-T*t))+(S*(t-D));          % (plin) for negative differential solution - from [1-40] thesis  
    test = tau(2) - tau(1);
    %if test > 0
    %    errorflag = 1;
    %    error.string = 'RadEv Func Error';
    %    error.inputno = 5;
    %    return
    %end
    while test < 0
        T = T*0.9999;
        tau = ((S*D)-(plin))*(exp(-T*t))+(S*(t-D));          
        test = tau(2) - tau(1);
    end
    if strcmp(DESTVis,'Yes') 
        figure(91); hold on; plot(tau(1:5),'b-','linewidth',2); xlabel('sample point'); ylabel('tau'); title('Timing Vector'); drawnow;
    end
    ind2 = find(tau < plout,1,'last');
    if ind2 > tMax
        errorflag = 1;
        error.string = 'Timing Vector Problem - Reduce Fineness';
        error.inputno = 0;
        return
    end
    tau = tau(1:ind2+10);
    inc = 0;
    N = 0.8;
    cont = 1;
    n = 0;
    err0 = 0;
    while cont == 1;
        tau0 = tau;
        ind1 = find(tau0 <= 0,1,'last');
        ind2 = find(tau0 >= 0,1,'first');
        if ind1 == ind2
            test;
            break
        end
        if abs(tau0(ind1)) < abs(tau0(ind2))
            ind = ind1;
        elseif abs(tau0(ind2)) < abs(tau0(ind1))
            ind = ind2;
        end
        err = abs(tau0(ind));
        inc = inc - sign(tau0(ind))*abs(tau0(ind))^(N);
        tau = ((S*D)-(plin)-inc)*(exp(-T*t))+(S*(t-D)) + inc;     % (plin) for negative differential solution - from [1-40] thesis
        n = n+1;
        if err < 1e-12
            if tau(2) < tau(1)
                if strcmp(DESTVis,'Yes') 
                    figure(91); hold on; plot(tau(1:5),'g-','linewidth',2); xlabel('sample point'); ylabel('tau'); title('Timing Vector'); drawnow;
                end
                T = T*0.9999;
                inc = 0;
                N = 0.8;
                err = 0;
                tau = ((S*D)-(plin))*(exp(-T*t))+(S*(t-D));  
                n = n+1;
            else
                break
            end
        elseif round(err*1e15) == round(err0*1e15)
            N = N+0.1;
        end
        if N > 1.0
            errorflag = 1;
            error.string = 'Timing Vector Problem (N)';
            error.inputno = 0;
            return
        end
        if n > 10000
            errorflag = 1;
            error.string = 'Timing Vector Problem (T)';
            error.inputno = 0;
            return
        end
        err0 = err;
    end
    SlvInd = ind;
    %tau = tau + abs(tau(SlvInd));
    tau1 = flipdim(tau(2:SlvInd),2);
    SlvInd2 = find(tau <= plout,1,'last');
    tau2 = tau(SlvInd:SlvInd2);
end
if strcmp(DESTVis,'Yes')  
    figure(91); hold on; plot(tau(1:5),'r-','linewidth',2); xlabel('sample point'); ylabel('tau'); title('Timing Vector');
end
if tau(2) < tau(1)
    errorflag = 1;
    error.string = 'Timing Vector Problem (negative)';
    error.inputno = 0;
    return
end