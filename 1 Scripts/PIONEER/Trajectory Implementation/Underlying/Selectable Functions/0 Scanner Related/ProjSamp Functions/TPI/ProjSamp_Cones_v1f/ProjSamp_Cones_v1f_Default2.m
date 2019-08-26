%=========================================================
% 
%=========================================================

function [default] = ProjSamp_Cones_v1f_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    addpath(genpath([SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\zz Common\']));
    projconedistpath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\ProjSamp SubFunctions\Projection-Cone Distribution\'];
    projangledistpath = [SCRPTPATHS.pioneerloc,'Trajectory Implementation\Underlying\zz Underlying\Selectable Functions\ProjSamp SubFunctions\Projection-Angle Distribution\'];
elseif strcmp(filesep,'/')
end
projconedist = 'ProjConeDist_TPI1_v1j';
projangledist = 'ProjAngleDist_TPI1_v2e';

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Ignore_USamp';
default{m,1}.entrystr = 'No';
default{m,1}.options = {'Yes','No'};

m = m+1;
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
