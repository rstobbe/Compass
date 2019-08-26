%=========================================================
% 
%=========================================================

function [default] = ImpMeth_LRideal_v2a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    DEsoltimpath = [SCRPTPATHS.pioneerloc,'Trajectory Design\Underlying\Selectable Functions\LR\DEsoltim Functions\']; 
    KSMPpath = [SCRPTPATHS.pioneerloc,'\Trajectory Implementation\Underlying\Selectable Functions\1 ImCon Related\kSamp Functions\']; 
    ProjSamppath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\ProjSamp Functions\LR\'];
    TrajSamppath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\Selectable Functions\0 Scanner Related\TrajSamp Functions\'];
elseif strcmp(filesep,'/')
end
DEsoltimfunc = 'DeSolTim_LRMeth2_v1b';
KSMPfunc = 'kSamp_Standard_v1c';
TrajSampfunc = 'TrajSamp_IdealLR_v1a';
ProjSampfunc = 'ProjSamp_SpecifyFull_v1e';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'DeSolTimfunc';
default{m,1}.entrystr = DEsoltimfunc;
default{m,1}.searchpath = DEsoltimpath;
default{m,1}.path = [DEsoltimpath,DEsoltimfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'kSampfunc';
default{m,1}.entrystr = KSMPfunc;
default{m,1}.searchpath = KSMPpath;
default{m,1}.path = [KSMPpath,KSMPfunc];

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

