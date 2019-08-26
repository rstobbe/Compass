%====================================================
%
%====================================================

function [default] = Coregister2Images_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    loadpath = [SCRPTPATHS.voyagerloc,'Image Format Related\Underlying\Selectable Functions\Load\Generic\'];
    coregpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Image Registration\Coregister\'];
elseif strcmp(filesep,'/')
end
loadfunc = 'ImMultiLoadGeneric_v1a';
coregfunc = 'CoregisterImages_v1a';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Image_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ImLoadfunc';
default{m,1}.entrystr = loadfunc;
default{m,1}.searchpath = loadpath;
default{m,1}.path = [loadpath,loadfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Coregfunc';
default{m,1}.entrystr = coregfunc;
default{m,1}.searchpath = coregpath;
default{m,1}.path = [coregpath,coregfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Coreg';
default{m,1}.labelstr = 'Coreg';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';

