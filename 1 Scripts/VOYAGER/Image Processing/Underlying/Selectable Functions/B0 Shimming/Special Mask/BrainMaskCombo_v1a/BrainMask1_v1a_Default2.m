%=========================================================
% 
%=========================================================

function [default] = BrainMask1_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    mask1path = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Image Masking\'];
    mask2path = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Image Masking\'];
elseif strcmp(filesep,'/')
end
mask1func = 'CubeMask_v1a';
mask2func = 'MinMaxFreqMask_v1a';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'MaskFoVfunc';
default{m,1}.entrystr = mask1func;
default{m,1}.searchpath = mask1path;
default{m,1}.path = [mask1path,mask1func];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'MaskFreqfunc';
default{m,1}.entrystr = mask2func;
default{m,1}.searchpath = mask2path;
default{m,1}.path = [mask2path,mask2func];


