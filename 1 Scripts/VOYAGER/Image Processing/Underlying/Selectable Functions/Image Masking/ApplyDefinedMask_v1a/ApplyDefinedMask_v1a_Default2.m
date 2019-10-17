%====================================================
%
%====================================================

function [default] = ApplyDefinedMask_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    maskpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\zz Underlying\Selectable Functions\Image Masking\'];
elseif strcmp(filesep,'/')
end
maskfunc = 'NoMask_v1a';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Maskfunc';
default{m,1}.entrystr = maskfunc;
default{m,1}.searchpath = maskpath;
default{m,1}.path = [maskpath,maskfunc];
