%=========================================================
% 
%=========================================================

function [default] = ImpMeth_DesignTest_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    radevpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\RadSolEv Functions\'];
    DEsoltimpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\DEsoltim Functions\']; 
    accconstpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\YarnBall\ConstEvol Functions\']; 
    ProjSamppath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\ProjSamp Functions\YarnBall\'];
    TrajSamppath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\TrajSamp Functions\'];
elseif strcmp(filesep,'/')
end
radevfunc = 'RadSolEv_DesignTest_v1b';
DEsoltimfunc = 'DeSolTim_YarnBallLookup_v1b';
accconstfunc = 'ConstEvol_None_v1a';
TrajSampfunc = 'TrajSamp_DesignTest_v1a';
ProjSampfunc = 'ProjSamp_SpecifyFull_v1e';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'RadSolEvfunc';
default{m,1}.entrystr = radevfunc;
default{m,1}.searchpath = radevpath;
default{m,1}.path = [radevpath,radevfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'DeSolTimfunc';
default{m,1}.entrystr = DEsoltimfunc;
default{m,1}.searchpath = DEsoltimpath;
default{m,1}.path = [DEsoltimpath,DEsoltimfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ConstEvolfunc';
default{m,1}.entrystr = accconstfunc;
default{m,1}.searchpath = accconstpath;
default{m,1}.path = [accconstpath,accconstfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'TrajSampfunc';
default{m,1}.entrystr = TrajSampfunc;
default{m,1}.searchpath = TrajSamppath;
default{m,1}.path = [TrajSamppath,TrajSampfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ProjSampfunc';
default{m,1}.entrystr = ProjSampfunc;
default{m,1}.searchpath = ProjSamppath;
default{m,1}.path = [ProjSamppath,ProjSampfunc];

