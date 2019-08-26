%====================================================
%
%====================================================

function [default] = PostProc_mpflash3d_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    ishimpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Intensity Shimming\'];
elseif strcmp(filesep,'/')
end
ishimfunc = 'ShimImageIntensityLPF_v2b';
addpath([ishimpath,ishimfunc]);

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Visuals';
default{m,1}.entrystr = 'Yes';
default{m,1}.options = {'Yes','No'};

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'IntensityShimfunc';
default{m,1}.entrystr = ishimfunc;
default{m,1}.searchpath = ishimpath;
default{m,1}.path = [ishimpath,ishimfunc];
