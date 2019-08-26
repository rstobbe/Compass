%====================================================
%
%====================================================

function [IMPTYPE,err] = ImpType_Basic_v1a_Func(IMPTYPE,INPUT)

Status2('busy','Create Basic Implementation',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%=================================================================
% PreDeSolTim
%=================================================================
if strcmp(INPUT.loc,'PreDeSolTim')

    %---------------------------------------------
    % Get Input
    %---------------------------------------------
    CLR = INPUT.CLR;
    SPIN = INPUT.SPIN;
    RADEV = INPUT.DESOL.RADEV;
    PROJdgn = INPUT.PROJdgn;
    clear INPUT;
    
    %---------------------------------------------
    % Get radial evolution function 
    %---------------------------------------------
    INPUT.PROJdgn = PROJdgn;
    func = str2func([RADEV.method,'_Func']);           
    [RADEV,err] = func(RADEV,INPUT);
    if err.flag
        return
    end
    clear INPUT;
   
    %------------------------------------------
    % Define Spinning Speeds
    %------------------------------------------
    stheta = @(r) 1/SPIN.spincalcndiscsfunc(r);  
    sphi = @(r) 1/SPIN.spincalcnspokesfunc(r);     

    %------------------------------------------
    % RadSolFuncs
    %------------------------------------------
    deradsolinfunc = str2func(['@(r,p)' RADEV.deradsolinfunc]);
    deradsolinfunc = @(r) deradsolinfunc(r,PROJdgn.p);
    deradsoloutfunc = str2func(['@(r,p)' RADEV.deradsoloutfunc]);
    deradsoloutfunc = @(r) deradsoloutfunc(r,PROJdgn.p);
    
    %---------------------------------------------
    % Create Basic Defuncs
    %---------------------------------------------
    INPUT.stheta = stheta;
    INPUT.sphi = sphi;
    INPUT.p = PROJdgn.p;
    INPUT.rad = PROJdgn.rad;
    INPUT.radslowfact = 1;
    INPUT.spinslowfact = 1;
    INPUT.dir = 1;
    INPUT.deradsolfunc = deradsoloutfunc;
    IMPTYPE.radevout = @(t,r) CLR.radevout(t,r,INPUT);
    IMPTYPE.ybcolourout = @(t,r) CLR.ybcolourout(t,r,INPUT);
    INPUT.deradsolfunc = deradsolinfunc;   
    IMPTYPE.radevin = @(t,r) CLR.radevin(t,r,INPUT);
    IMPTYPE.ybcolourin = @(t,r) CLR.ybcolourin(t,r,INPUT);    
    IMPTYPE.MaxRadSolve = 1;

%=================================================================
% PreGeneration
%=================================================================
elseif strcmp(INPUT.loc,'PreGeneration')

    %---------------------------------------------
    % Get Input
    %---------------------------------------------
    PROJdgn = INPUT.PROJdgn;
    PSMP = INPUT.PSMP;
    DESOL = INPUT.DESOL;
    clear INPUT;
    
    %---------------------------------------------
    % Solution Values
    %---------------------------------------------    
    IMPTYPE.rad0 = PROJdgn.p;
    IMPTYPE.phi0 = PSMP.phi;
    IMPTYPE.theta0 = PSMP.theta;
    IMPTYPE.tau1 = DESOL.tau1;
    IMPTYPE.tau2 = DESOL.tau2;
    IMPTYPE.len = DESOL.len;
    IMPTYPE.dir = 1;
end


    