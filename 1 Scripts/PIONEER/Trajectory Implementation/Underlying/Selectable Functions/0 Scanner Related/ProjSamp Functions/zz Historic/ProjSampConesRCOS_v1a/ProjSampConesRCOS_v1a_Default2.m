%=========================================================
% 
%=========================================================

function [default] = ProjSampConesRCOS_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\zz Common\']));
    projconedistpath = [SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\InitialProjectionVector Functions\Projection-Cone Distribution'];
    projangledistpath = [SCRPTPATHS.rootloc,'Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\InitialProjectionVector Functions\Projection-Angle Distribution'];
elseif strcmp(filesep,'/')
end
projconedist = 'pcd4aRCOS_v1b';
addpath(genpath(projconedistpath));
projangledist = 'pad2aRCOS_v2c';
addpath(genpath(projangledistpath));

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'rStdevPhi';
default{m,1}.entrystr = '0.25';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'rStdevTheta';
default{m,1}.entrystr = '0.25';

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