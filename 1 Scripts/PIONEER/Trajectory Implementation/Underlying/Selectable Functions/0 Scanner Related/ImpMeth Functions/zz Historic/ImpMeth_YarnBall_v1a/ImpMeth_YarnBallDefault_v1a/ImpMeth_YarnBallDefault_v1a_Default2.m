%=========================================================
% 
%=========================================================

function [default] = ImpMeth_YarnBallDefault_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    radevpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\RadSolEv Functions\'];
    DEsoltimpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\DeSolTim Functions\']; 
    accconstpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\ConstEvol Functions\']; 
    ProjSamppath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\ProjSamp Functions\YarnBall\'];
    TrajSamppath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\TrajSamp Functions\'];
    TrajEndpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\GWFM SubFunctions\TrajEnd Functions\']; 
    SYSRESPpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\SysResp SubFunctions\']; 
    ORNTpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\Orient Functions\'];
    KSMPpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\Selectable Functions\1 ImCon Related\kSamp Functions\'];     
elseif strcmp(filesep,'/')
end
radevfunc = 'RadSolEv_ForConstEvol_v1a';
DEsoltimfunc = 'DeSolTim_YarnBallLookup_v1b';
accconstfunc = 'ConstEvol_ShapeAlongTraj_v1a';
TrajSampfunc = 'TrajSamp_SiemensLR_v3h';
ProjSampfunc = 'ProjSamp_Wool_v1a';
TrajEndfunc = 'TrajEnd_StandardSpoil_v1b';
SYSRESPfunc = 'SysResp_FromFileWithComp_v1f'; 
ORNTfunc = 'OrientFlexible_v1b'; 
KSMPfunc = 'kSamp_Standard_v1c';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Orientfunc';
default{m,1}.entrystr = ORNTfunc;
default{m,1}.searchpath = ORNTpath;
default{m,1}.path = [ORNTpath,ORNTfunc];

% m = m+1;
% default{m,1}.entrytype = 'ScrptFunc';
% default{m,1}.labelstr = 'RadSolEvfunc';
% default{m,1}.entrystr = radevfunc;
% default{m,1}.searchpath = radevpath;
% default{m,1}.path = [radevpath,radevfunc];

% m = m+1;
% default{m,1}.entrytype = 'ScrptFunc';
% default{m,1}.labelstr = 'DeSolTimfunc';
% default{m,1}.entrystr = DEsoltimfunc;
% default{m,1}.searchpath = DEsoltimpath;
% default{m,1}.path = [DEsoltimpath,DEsoltimfunc];

% m = m+1;
% default{m,1}.entrytype = 'ScrptFunc';
% default{m,1}.labelstr = 'ConstEvolfunc';
% default{m,1}.entrystr = accconstfunc;
% default{m,1}.searchpath = accconstpath;
% default{m,1}.path = [accconstpath,accconstfunc];

% m = m+1;
% default{m,1}.entrytype = 'ScrptFunc';
% default{m,1}.labelstr = 'TrajEndfunc';
% default{m,1}.entrystr = TrajEndfunc;
% default{m,1}.searchpath = TrajEndpath;
% default{m,1}.path = [TrajEndpath,TrajEndfunc];

% m = m+1;
% default{m,1}.entrytype = 'ScrptFunc';
% default{m,1}.labelstr = 'SysRespfunc';
% default{m,1}.entrystr = SYSRESPfunc;
% default{m,1}.searchpath = SYSRESPpath;
% default{m,1}.path = [SYSRESPpath,SYSRESPfunc];

% m = m+1;
% default{m,1}.entrytype = 'ScrptFunc';
% default{m,1}.labelstr = 'TrajSampfunc';
% default{m,1}.entrystr = TrajSampfunc;
% default{m,1}.searchpath = TrajSamppath;
% default{m,1}.path = [TrajSamppath,TrajSampfunc];

% m = m+1;
% default{m,1}.entrytype = 'ScrptFunc';
% default{m,1}.labelstr = 'kSampfunc';
% default{m,1}.entrystr = KSMPfunc;
% default{m,1}.searchpath = KSMPpath;
% default{m,1}.path = [KSMPpath,KSMPfunc];

% m = m+1;
% default{m,1}.entrytype = 'ScrptFunc';
% default{m,1}.labelstr = 'ProjSampfunc';
% default{m,1}.entrystr = ProjSampfunc;
% default{m,1}.searchpath = ProjSamppath;
% default{m,1}.path = [ProjSamppath,ProjSampfunc];

