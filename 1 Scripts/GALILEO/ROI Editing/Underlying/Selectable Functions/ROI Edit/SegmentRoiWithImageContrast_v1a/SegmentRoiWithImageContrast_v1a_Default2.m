%====================================================
%
%====================================================

function [default] = CreateRoiFromImage_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    loadpath = [SCRPTPATHS.voyagerloc,'Image Format Related\Underlying\Selectable Functions\Load\Generic\'];
    maskpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\zz Underlying\Selectable Functions\Image Masking\'];
elseif strcmp(filesep,'/')
end
loadfunc = 'Im1LoadGeneric_v1c';
maskfunc = 'IntenseMaskValue_v1b';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ImLoadfunc';
default{m,1}.entrystr = loadfunc;
default{m,1}.searchpath = loadpath;
default{m,1}.path = [loadpath,loadfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Maskfunc';
default{m,1}.entrystr = maskfunc;
default{m,1}.searchpath = maskpath;
default{m,1}.path = [maskpath,maskfunc];