%=========================================================
% 
%=========================================================

function [default] = ProjSampCones_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\zz Common\']));
    projconedistpath = [SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\ProjSamp SubFunctions\Projection-Cone Distribution'];
    projangledistpath = [SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\ProjSamp SubFunctions\Projection-Angle Distribution'];
elseif strcmp(filesep,'/')
end
projconedist = 'pcd4a_v1e';
addpath(genpath(projconedistpath));
projangledist = 'pad2a_v2c';
addpath(genpath(projangledistpath));

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ProjConeDist';
default{m,1}.entrystr = projconedist;
default{m,1}.searchpath = projconedistpath;

m = m+1;
default{m,1}.entrytype = 'UnderFunc';
default{m,1}.labelstr = 'ProjAngleDist';
default{m,1}.entrystr = projangledist;
default{m,1}.searchpath = projangledistpath;