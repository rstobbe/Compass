%=====================================================
% 
%=====================================================

function [GRD,err] = CreateSpiralTestUSL_v1a_Func(GRD,INPUT)

Status('busy','Create Spiral Trajectory Test');
Status2('done','',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
WRTP = INPUT.WRTP;
GradFolder = INPUT.GradFolder;
IMP = INPUT.IMP;
clear INPUT

%---------------------------------------------
% Define Trajectory
%---------------------------------------------
usetrajnum = GRD.usetrajnum;
usetrajdir = GRD.usetrajdir;

Traj = ['G',usetrajdir,num2str(usetrajnum)];

%---------------------------------------------
% Write Parameter File
%--------------------------------------------- 
func = str2func([GRD.wrtparamfunc,'_Func']);
INPUT.gontime = IMP.GWFM.tgwfm;
INPUT.gval = 0;
INPUT.gvalinparam = 0;
INPUT.slewrate = 0;
INPUT.falltime = 0;
INPUT.pnum = 1;
INPUT.GradLoc = [GradFolder,'\',Traj];
[WRTP,err] = func(WRTP,INPUT);
if err.flag 
    return
end
clear INPUT

%---------------------------------------------
% Return
%--------------------------------------------- 
GRD.WRTP = WRTP;


