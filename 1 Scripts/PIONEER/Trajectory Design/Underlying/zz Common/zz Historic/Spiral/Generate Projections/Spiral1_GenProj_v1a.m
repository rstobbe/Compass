%====================================================
% (v1a)
%     
%====================================================

function [DES,err] = Spiral1_GenProj_v1a(INPUT)

Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Test for Common Routines
%---------------------------------------------
DES.de = 'Spiral1_Sol_v1a';
if not(exist(DES.de,'file'))
    err.flag = 1;
    err.msg = 'Folder of common Spiral routines must be added to path';
    return
end

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
SPIN = INPUT.SPIN;
DESOL = INPUT.DESOL;
PSMP = INPUT.PSMP;
TST = INPUT.TST;
RADEV = DESOL.RADEV;
clear INPUT;

%---------------------------------------------
% Specify Common Variables
%---------------------------------------------
rad = PROJdgn.rad;
p = PROJdgn.p;
tro = PROJdgn.tro;

%------------------------------------------
% Define Polar Angle Evolution Functions
%------------------------------------------
spincalcnprojfunc = SPIN.spincalcnprojfunc;   
stheta = @(r) (2*pi*rad)/spincalcnprojfunc(r);  

%------------------------------------------
% Setup Differection Equation Solver
%------------------------------------------
optionsIn = odeset('RelTol',RADEV.solintol,'AbsTol',[RADEV.solintol,RADEV.solintol]);
optionsOut = odeset('RelTol',RADEV.solouttol,'AbsTol',[RADEV.solouttol,RADEV.solouttol]);
defunc = str2func(DES.de);
tau1 = DESOL.tau1;
tau2 = DESOL.tau2;
deradsolfunc = str2func(['@(r,p)' DESOL.RADEV.deradsolfunc]);
deradsolfunc = @(r) deradsolfunc(r,p);
theta0 = PSMP.theta;
KSA = zeros(length(theta0),DESOL.len,2);

%==========================================
% Solve
%==========================================
for n = 1:length(theta0) 

    %------------------------------------------
    % Solve Differential Equations
    %------------------------------------------    
    Status2('busy',['Generate Trajectory Number: ',num2str(n)],2);
    if strcmp(TST.initstrght,'Yes')                     % testing option
        r1 = p;
        phi1 = phi0(n);
        theta1 = theta0(n);
    else
        [x,Y] = ode113(defunc,tau1,[p,theta0(n)],optionsIn,deradsolfunc,stheta); 
        %[x,Y] = ode45(defunc,tau1,[p,theta0(n)],options,deradsolfunc,stheta);
        r1 = real(Y(:,1))';  
        theta1 = real(Y(:,2))';
        if length(x) ~= length(tau1)
            err.flag = 1;
            err.msg = 'SolInTol value too small';
            return
        end
        if r1(length(r1)) < 0
            last10rad = r1(length(r1)-10:length(r1))
            err.flag = 1;
            err.msg = 'Negative DE Solution Problem. Adjust DE solution timing';
            return
        end
        testshow = 1;
        if testshow == 1
            figure(500); hold on
            plot([0 flipdim(r1,2)]);
            title('Initial Data Points');
            ylabel('Relative Radius'); xlabel('Data Point');
        end
    end
    [x,Y] = ode113(defunc,tau2,[p,theta0(n)],optionsOut,deradsolfunc,stheta);
    %[x,Y] = ode45(defunc,tau2,[p,theta0(n)],options,deradsolfunc,stheta);
    
    r = [0 flipdim(r1,2) real(Y(2:length(tau2),1))'];
    theta = [0 flipdim(theta1,2) real(Y(2:length(tau2),2))'];
    
    %if round(max(r)*1000)/1000 < 1
    if round(max(r)*500)/500 < 1
    %if round(max(r)*250)/250 < 1    
        test = max(r)
        error('DE Not Solved to End of Trajectory');
    end

    %------------------------------------------
    % Calculate k-Space Array
    %------------------------------------------
    slvno = length(r);
    kArr(:,1) = r.*cos(theta);                              
    kArr(:,2) = r.*sin(theta);
    
    %------------------------------------------
    % Calculate Real Timings
    %------------------------------------------
    if strcmp(TST.initstrght,'Yes')
        tautot = p+[-p flipdim(tau1,2) tau2(2:length(tau2))];
    else
        tautot = (DESOL.plin)+[-(DESOL.plin) flipdim(tau1,2) tau2(2:length(tau2))];      % (plin) for negative differential solution - from [1-40] thesis
    end    
    projlen0 = tautot(slvno);
    realT = (1/projlen0)*tro;
    TArr = tautot*realT;

    %------------------------------------------
    % Save
    %------------------------------------------    
    KSA(n,:,:) = kArr;
end

%------------------------------------------
% Return
%------------------------------------------    
DES.projlen0 = projlen0;
DES.T = TArr;
DES.KSA = KSA;
    
Status2('done','',2);
Status2('done','',3);



