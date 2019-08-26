%=========================================================
% 
%=========================================================

function [default] = ShimImageIntensitySphH_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    fitpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\zz Underlying\Selectable Functions\Fit Spherical Harmonics\'];
elseif strcmp(filesep,'/')
end
fitfunc = 'Fit3DegSphHarm_v1a';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Fitfunc';
default{m,1}.entrystr = fitfunc;
default{m,1}.searchpath = fitpath;
default{m,1}.path = [fitpath,fitfunc];

