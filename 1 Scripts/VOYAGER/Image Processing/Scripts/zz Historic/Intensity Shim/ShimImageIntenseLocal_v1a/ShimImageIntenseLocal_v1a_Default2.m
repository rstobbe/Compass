%=========================================================
% 
%=========================================================

function [default] = ShimImageIntenseLocal_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    fitpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Shimming\Intensity\'];
elseif strcmp(filesep,'/')
end
fitfunc = 'ShimImageIntensity_v1a';
addpath([fitpath,fitfunc]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Image_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Fitfunc';
default{m,1}.entrystr = fitfunc;
default{m,1}.searchpath = fitpath;
default{m,1}.path = [fitpath,fitfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Shim';
default{m,1}.labelstr = 'Shim';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';