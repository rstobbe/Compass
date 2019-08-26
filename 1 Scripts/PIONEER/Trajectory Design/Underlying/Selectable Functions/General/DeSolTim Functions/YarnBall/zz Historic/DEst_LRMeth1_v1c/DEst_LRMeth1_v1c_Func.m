%====================================================
% 
%====================================================

function [DESOL,err] = DEst_LRMeth1_v1c_Func(DESOL,INPUT)

Status2('done','Determine Timing With Which to Solve DE',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test for Common Routines
%---------------------------------------------
DESOL.projlenoutfunc = 'LR1_ProjLenOutside_v1c';
DESOL.projleninfunc = 'LR1_ProjLenInside_v1c';
if not(exist(DESOL.projlenoutfunc,'file'))
    err.flag = 1;
    err.msg = 'Folder with DESOL routines must be added to path';
    return
end
projlenoutfunc = str2func(DESOL.projlenoutfunc);
projleninfunc = str2func(DESOL.projleninfunc);

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
TST = INPUT.TST;
RADEV = DESOL.RADEV;
clear INPUT;

%---------------------------------------------
% Common Variables
%---------------------------------------------
p = PROJdgn.p;
fineness = DESOL.fineness;

%---------------------------------------------
% Function Setup
%---------------------------------------------
radevfunc = str2func([DESOL.radevfunc,'_Func']);  

%------------------------------------------
% Get radial evolution function for DE solution timing
%------------------------------------------
INPUT.PROJdgn = PROJdgn;         
[RADEV,err] = radevfunc(RADEV,INPUT);
if err.flag == 1
    return
end
clear INPUT;
deradsolfunc = str2func(['@(r,p)' RADEV.deradsolfunc]);
deradsolfunc = @(r) deradsolfunc(r,p);

%------------------------------------------
% Visuals
%------------------------------------------
if strcmp(DESOL.Vis,'Yes') 
    r = (0:0.01:1);
    figure(2020); hold on; 
    plot(r,1./(r.^2.*deradsolfunc(r)),'k-','linewidth',2); 
    xlabel('Relative Radial Value'); ylabel('Radial Evolution Value for Solution Generation');
end

%------------------------------------------
% Calculate Projection Lengths
%------------------------------------------
Status2('busy','Calculate Trajectory Lengths',2);
[plout,err] = projlenoutfunc(p,deradsolfunc,RADEV.outtol);                    
if err.flag == 1
    return
end
[plin,err] = projleninfunc(p,deradsolfunc,RADEV.intol);     
if err.flag == 1
    return
end

%------------------------------------------
% Create Timing Arrays for Solving
%------------------------------------------
Status2('busy','Create Timing Vector',2);
D = RADEV.D;                                         % shape
if fineness == 1
    %S = 0.06;                                       % slope                                    
    %T = 0.0002510;                                  % shape (fit by alg)
    S = 0.06;                                                                            
    T = 0.0002510;                                  
elseif fineness == 2
    S = 0.03;
    T = 0.0002510;  
elseif fineness == 3
    S = 0.020;
    T = 0.0002510; 
elseif fineness == 4
    S = 0.015;
    T = 0.0002515;                                  
elseif fineness == 5
    S = 0.010;
    T = 0.000252;                                  
elseif fineness == 6
    S = 0.005;
    T = 0.000254;                                  
elseif fineness == 7
    S = 0.0025;
    T = 0.000255;                                  
elseif fineness == 8
    S = 0.001;
    T = 0.00015;                                  
end
tMax = 1e6;
%tMax = 300000;                                       % doesn't really matter just set sufficiently big
t = (0:tMax);                                    
if strcmp(TST.initstrght,'Yes')
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
    while test < 0
        T = T*0.9999;
        tau = ((S*D)-(plin))*(exp(-T*t))+(S*(t-D));          
        test = tau(2) - tau(1);
    end
    if strcmp(DESOL.Vis,'Yes') 
        figure(91); hold on; plot(tau(1:5),'b-','linewidth',2); 
        xlabel('sample point'); ylabel('tau'); title('Timing Vector'); drawnow;
    end
    ind2 = find(tau < plout,1,'last');
    if ind2 > tMax
        err.flag = 1;
        err.msg = 'Timing Vector Problem - Reduce Fineness';
        return
    end
    tau = tau(1:ind2+10);
    inc = 0;
    N = 0.8;
    cont = 1;
    n = 0;
    err0val = 0;
    while cont == 1;
        tau0 = tau;
        ind1 = find(tau0 <= 0,1,'last');
        ind2 = find(tau0 >= 0,1,'first');
        if ind1 == ind2
            break
        end
        if abs(tau0(ind1)) < abs(tau0(ind2))
            ind = ind1;
        elseif abs(tau0(ind2)) < abs(tau0(ind1))
            ind = ind2;
        end
        errval = abs(tau0(ind));
        inc = inc - sign(tau0(ind))*abs(tau0(ind))^(N);
        tau = ((S*D)-(plin)-inc)*(exp(-T*t))+(S*(t-D)) + inc;     % (plin) for negative differential solution - from [1-40] thesis
        n = n+1;
        if errval < 1e-12
            if tau(2) < tau(1)
                if strcmp(DESOL.Vis,'Yes') 
                    figure(91); hold on; plot(tau(1:5),'g-','linewidth',2); xlabel('sample point'); ylabel('tau'); title('Timing Vector'); drawnow;
                end
                T = T*0.9999;
                inc = 0;
                N = 0.8;
                errval = 0;
                tau = ((S*D)-(plin))*(exp(-T*t))+(S*(t-D));  
                n = n+1;
            else
                break
            end
        elseif round(errval*1e15) == round(err0val*1e15)
            if strcmp(DESOL.search,'weak')
                N = N+0.1;
            elseif strcmp(DESOL.search,'strong')
                N = N+0.01;
            end
        end
        if N > 1.0
            err.flag = 1;
            err.msg = 'Increase Search Power';
            return
        end
        if n > 1000
            err.flag = 1;
            err.msg = 'Timing Vector Problem - Try Reducing Fineness';
            return
            %error('Timing Vector Problem (D param) - fix');
        end
        err0val = errval;
    end
    SlvInd = ind;
    tau1 = flipdim(tau(2:SlvInd),2);
    SlvInd2 = find(tau <= plout,1,'last');
    tau2 = tau(SlvInd:SlvInd2);
end

%------------------------------------------
% Visualize
%------------------------------------------
if strcmp(DESOL.Vis,'Yes')
    figure(91); hold on; plot(tau(1:5),'r-','linewidth',2); 
    xlabel('sample point'); ylabel('tau'); title('Timing Vector');
    figure(92); hold on; plot(tau,'b-'); 
    xlabel('sample point'); ylabel('tau'); title('Timing Vector');    
end

%------------------------------------------
% Test
%------------------------------------------
if tau(2) < tau(1)
    err.flag = 1;
    err.msg = 'Timing Vector Problem (negative)';
    return
end
%test = T

%------------------------------------------
% Return
%------------------------------------------
DESOL.RADEV = RADEV;
DESOL.tau1 = tau1;
DESOL.tau2 = tau2;
DESOL.len = length(tau1)+length(tau2);
DESOL.plin = plin;
DESOL.plout = plout;

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
DESOL.PanelOutput = struct();
Status2('done','',2);
Status2('done','',3);
