%=========================================================
% 
%=========================================================

function [default] = ProjSamp_Cones_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\zz Common\']));
    projconedistpath = [SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\ProjSamp SubFunctions\Projection-Cone Distribution\'];
    projangledistpath = [SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\ProjSamp SubFunctions\Projection-Angle Distribution\'];
elseif strcmp(filesep,'/')
end
projconedist = 'pcd4a_v1e';
projangledist = 'pad2a_v2c';

addpath([projconedistpath,projconedist]);
addpath([projangledistpath,projangledist]);

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ProjConeDist';
default{m,1}.entrystr = projconedist;
default{m,1}.searchpath = projconedistpath;
default{m,1}.path = [projconedistpath,projconedist];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ProjAngleDist';
default{m,1}.entrystr = projangledist;
default{m,1}.searchpath = projangledistpath;
default{m,1}.path = [projangledistpath,projangledist];