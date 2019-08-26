%=========================================================
% 
%=========================================================

function [default] = ShimImageIntensitySphH_v1c_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    fitpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\zz Underlying\Selectable Functions\Fit Spherical Harmonics\'];
    maskpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\zz Underlying\Selectable Functions\Image Masking\'];    
elseif strcmp(filesep,'/')
end
fitfunc = 'Fit3DegSphHarm_v1a';
maskfunc = 'NoMask_v1a';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RelMinVal';
default{m,1}.entrystr = '0.1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RelMaxVal';
default{m,1}.entrystr = '0.6';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Maskfunc';
default{m,1}.entrystr = maskfunc;
default{m,1}.searchpath = maskpath;
default{m,1}.path = [maskpath,maskfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Fitfunc';
default{m,1}.entrystr = fitfunc;
default{m,1}.searchpath = fitpath;
default{m,1}.path = [fitpath,fitfunc];

