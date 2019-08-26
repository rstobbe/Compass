%=========================================================
% 
%=========================================================

function [default] = ProjSamp_Cones_v1e_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\zz Common\']));
    projconedistpath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\ProjSamp SubFunctions\Projection-Cone Distribution\'];
    projangledistpath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\ProjSamp SubFunctions\Projection-Angle Distribution\'];
elseif strcmp(filesep,'/')
end
projconedist = 'ProjConeDist_TPI1_v1k';
projangledist = 'ProjAngleDist_TPI1_v2e';
addpath([projconedistpath,projconedist]);
addpath([projangledistpath,projangledist]);

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ProjConeDistfunc';
default{m,1}.entrystr = projconedist;
default{m,1}.searchpath = projconedistpath;
default{m,1}.path = [projconedistpath,projconedist];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ProjAngleDistfunc';
default{m,1}.entrystr = projangledist;
default{m,1}.searchpath = projangledistpath;
default{m,1}.path = [projangledistpath,projangledist];