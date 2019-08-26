%=========================================================
% 
%=========================================================

function [default] = PSinittest_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\zz Common\']));
    projconedistpath = [SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\InitialProjectionVector Functions\Projection-Cone Distribution'];
    projangledistpath = [SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\InitialProjectionVector Functions\Projection-Angle Distribution'];
elseif strcmp(filesep,'/')
end
projconedist = 'pcd4a_v1b';
addpath(genpath(projconedistpath));
projangledist = 'pad2a_v2b';
addpath(genpath(projangledistpath));

m = 1;
default{m,1}.entrytype = 'StatInput';
default{m,1}.labelstr = 'ReconOS';
default{m,1}.entrystr = '2.0';

m = m+1;
default{m,1}.entrytype = 'UnderFunc';
default{m,1}.labelstr = 'ProjConeDist';
default{m,1}.entrystr = projconedist;
default{m,1}.searchpath = projconedistpath;

m = m+1;
default{m,1}.entrytype = 'UnderFunc';
default{m,1}.labelstr = 'ProjAngleDist';
default{m,1}.entrystr = projangledist;
default{m,1}.searchpath = projangledistpath;