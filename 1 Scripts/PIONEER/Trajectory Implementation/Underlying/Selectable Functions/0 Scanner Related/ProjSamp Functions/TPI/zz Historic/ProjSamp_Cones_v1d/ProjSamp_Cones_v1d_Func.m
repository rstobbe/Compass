%====================================================
% 
%====================================================

function [PSMP,err] = ProjSamp_Cones_v1d_Func(PSMP,INPUT)

Status2('busy','Define Projection Sampling',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
testing = INPUT.testing;
tnproj = INPUT.tnproj;
clear INPUT

%---------------------------------------------
% Get Working Structures / Variables
%---------------------------------------------
PCD = PSMP.PCD;
PAD = PSMP.PAD;

%----------------------------------------------------
% Projection-Cone Distribution
%----------------------------------------------------  
func = str2func([PSMP.PCDfunc,'_Func']);
INPUT.PROJdgn = PROJdgn;
[PCD,err] = func(PCD,INPUT);
if err.flag
    return
end
clear INPUT

%----------------------------------------------------
% Test
%---------------------------------------------------- 
if PCD.osamp_phi < 1 || PCD.osamp_theta < 1
    osamp_phi = PCD.osamp_phi
    osamp_theta = PCD.osamp_theta
    err.flag = 1;
    err.msg = 'increase #projs';
    return
end

%----------------------------------------------------
% Projection-Angle Distribution
%---------------------------------------------------- 
PCDforPAD = PCD;
if strcmp(testing,'Yes')
    PCDforPAD.ncones = tnproj*2;
    PCDforPAD.nprojcone = ones(1,tnproj*2);                                 
    PCDforPAD.phi = flipdim((0:(pi/(2*tnproj-1)):pi/2),2);
    PCDforPAD.conephi = [PCDforPAD.phi PCDforPAD.phi];
    PCD.testncones = PCDforPAD.ncones;
    PCD.testnprojcone = PCDforPAD.nprojcone;
    PCD.testconephi = PCDforPAD.conephi;
else
    PCDforPAD = PCD;
end
    
%----------------------------------------------------
% Projection-Angle Distribution
%----------------------------------------------------  
func = str2func([PSMP.PADfunc,'_Func']);   
INPUT.PCD = PCDforPAD;
[PAD,err] = func(PAD,INPUT);
if err.flag
    return
end
clear INPUT;

%----------------------------------------------------
% Return
%----------------------------------------------------  
PSMP.IV = PAD.IV;
PSMP.projosamp = PCD.projosamp;
PSMP.osamp_phi = PCD.osamp_phi;
PSMP.osamp_theta = PCD.osamp_theta;
PSMP.nproj = PCD.nproj;
PSMP.PCD = PCD;
PSMP.PAD = PAD;

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'projosamp',PSMP.projosamp,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
PSMP.PanelOutput = PanelOutput;




