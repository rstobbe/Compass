%=========================================================
% 
%=========================================================

function [IMP,err] = LR_Ideal_v2b_Func(INPUT)

Status('busy','Implement Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';
IMP = struct();

%---------------------------------------------
% Get Input
%---------------------------------------------
DES = INPUT.DES;
PROJimp = INPUT.PROJimp;
PSMP = INPUT.PSMP;
TSMP = INPUT.TSMP;
KSMP = INPUT.KSMP;
PROJdgn = DES.PROJdgn;

%---------------------------------------------
% Common Variables
%---------------------------------------------
testingonly = INPUT.testingonly;

%---------------------------------------------
% Test for Common Routines
%---------------------------------------------
PROJimp.genprojfunc = 'LR1_GenProj_v1b';
if not(exist(PROJimp.genprojfunc,'file'))
    err.flag = 1;
    err.msg = 'Folder of Common LR routines must be added to path';
    return
end
genprojfunc = str2func(PROJimp.genprojfunc);

%------------------------------------------
% Projection Sampling
%------------------------------------------
if strcmp(testingonly,'Yes');
    PSMP.phi = pi/2;
    PSMP.theta = 0;
else    
    INPUT.PROJdgn = PROJdgn;
    func = str2func([PROJimp.psmpmeth,'_Func']);           
    [PSMP,err] = func(PSMP,INPUT);
    if err.flag
        return
    end
    clear INPUT;
end
       
%------------------------------------------
% Testing
%------------------------------------------
TST.initstrght = 'No';
TST.constacc = 'Yes';    

%------------------------------------------
% Visualization 
%------------------------------------------
DES.SPIN.Vis = 'No';
DES.CACC.Vis = 'No';   

%---------------------------------------------
% Generate Trajectories
%---------------------------------------------
Status('busy','Generate Trajectories');
INPUT = DES;
INPUT.PSMP = PSMP;
INPUT.TST = TST;
[OUTPUT,err] = genprojfunc(INPUT);
if err.flag
    return
end
clear INPUT;

%---------------------------------------------
% Testing
%---------------------------------------------
if strcmp(testingonly,'Yes');
    testmaxsmpdwell = PROJdgn.kstep/max(OUTPUT.CACC.magvelpost);
    if testmaxsmpdwell ~= PROJdgn.maxsmpdwell;
        error();
    end
end

%---------------------------------------------
% Store Trajectories
%---------------------------------------------
KSA = OUTPUT.KSA;
T = OUTPUT.T;
clear OUTPUT;

%----------------------------------------------------
% Define Sampling
%----------------------------------------------------
INPUT.PROJdgn = PROJdgn;
func = str2func([PROJimp.tsmpmeth,'_Func']);  
[TSMP,err] = func(TSMP,INPUT);
if err.flag
    return
end
clear INPUT;

%----------------------------------------------------
% Sample k-Space
%----------------------------------------------------
INPUT.PROJdgn = PROJdgn;
INPUT.TSMP = TSMP;
INPUT.KSA = KSA;
INPUT.T = T;
func = str2func([PROJimp.ksmpmeth,'_Func']);  
[KSMP,err] = func(KSMP,INPUT);
if err.flag
    return
end
clear INPUT;
IMP.Kmat = KSMP.Kmat;
KSMP = rmfield(KSMP,'Kmat');

%---------------------------------------
% Consolidate PROJimp
%---------------------------------------
PROJimp.nproj = PROJdgn.nproj;
PROJimp.npro = TSMP.npro;
PROJimp.sampstart = TSMP.sampstart;
PROJimp.dwell = TSMP.dwell;
PROJimp.trajosamp = TSMP.trajosamp;
PROJimp.projosamp = PROJdgn.projosamp;
PROJimp.maxrelkmax = 1;
PROJimp.meanrelkmax = 1;

%---------------------------------------
% Output
%---------------------------------------
IMP.PROJimp = PROJimp;
IMP.PSMP = PSMP;
IMP.TSMP = TSMP;
IMP.KSMP = KSMP;


