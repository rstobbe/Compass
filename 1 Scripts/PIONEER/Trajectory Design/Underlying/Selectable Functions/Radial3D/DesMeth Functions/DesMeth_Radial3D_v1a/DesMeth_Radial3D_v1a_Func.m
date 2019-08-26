%==================================================
% 
%==================================================

function [DESMETH,err] = DesMeth_Radial3D_v1a_Func(DESMETH,INPUT)

Status('busy','Create Radial3D Design');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
clear INPUT

%---------------------------------------------
% Describe Trajectory
%---------------------------------------------
DESMETH.type = 'Rad3D';

%------------------------------------------
% Calculate undersampling
%------------------------------------------
TrajNeeded = 4*pi*((PROJdgn.fov/PROJdgn.vox)/2)^2;
PROJdgn.projosamp = PROJdgn.nproj/TrajNeeded;
PROJdgn.fovsupported = sqrt(PROJdgn.nproj/(4*pi))*PROJdgn.vox*2;

%--------------------------------------------
% Name
%--------------------------------------------
sfov = num2str(PROJdgn.fov,'%03.0f');
svox = num2str(10*(PROJdgn.vox^3),'%04.0f');
stro = num2str(10*PROJdgn.tro,'%03.0f');
snproj = num2str(PROJdgn.nproj,'%4.0f');
DESMETH.name = ['DES_F',sfov,'_V',svox,'_T',stro,'_N',snproj];    
    
%------------------------------------------
% Return
%------------------------------------------
DESMETH.PROJdgn = PROJdgn;
DESMETH.PanelOutput = [];
DESMETH.Panel2Imp = [];

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'Method',DESMETH.method,'Output'};
Panel(2,:) = {'FoV Design (mm)',PROJdgn.fov,'Output'};
Panel(3,:) = {'VoxWidNom (mm)',PROJdgn.vox,'Output'};
Panel(4,:) = {'VoxWidCeq (mm)',PROJdgn.vox*1.24,'Output'};
Panel(5,:) = {'VoxVol (mm3)',((PROJdgn.vox*1.24)^3),'Output'};
Panel(6,:) = {'Tro (ms)',PROJdgn.tro,'Output'};
Panel(7,:) = {'Ntraj',PROJdgn.nproj,'Output'};
Panel(8,:) = {'UnderSamp',PROJdgn.projosamp,'Output'};
Panel(9,:) = {'FoV Supported (mm)',round(PROJdgn.fovsupported),'Output'};

DESMETH.PanelOutput = cell2struct(Panel,{'label','value','type'},2);
DESMETH.Panel2Imp = Panel;

Status('done','');
Status2('done','',2);
Status2('done','',3);


