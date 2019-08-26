%=========================================================
% 
%=========================================================

function [default] = B0Mapping_v1d_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    loadpath = [SCRPTPATHS.voyagerloc,'Image Format Related\Underlying\Selectable Functions\Load\Generic\'];
    mappath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\B0 Field Mapping\Mapping\'];
    baseimpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Base Image for Mapping\'];
elseif strcmp(filesep,'/')
end
loadfunc = 'Im1LoadGeneric_v1c';
baseimfunc = 'AbsCombine_v1a';
mapfunc = 'B0MapSingleRcvr_v1b';

m = 1;
default{m,1}.entrytype = 'OutputName';
default{m,1}.labelstr = 'Image_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScriptName';
default{m,1}.labelstr = 'Script_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ImLoadfunc';
default{m,1}.entrystr = loadfunc;
default{m,1}.searchpath = loadpath;
default{m,1}.path = [loadpath,loadfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'BaseImfunc';
default{m,1}.entrystr = baseimfunc;
default{m,1}.searchpath = baseimpath;
default{m,1}.path = [baseimpath,baseimfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'B0Mapfunc';
default{m,1}.entrystr = mapfunc;
default{m,1}.searchpath = mappath;
default{m,1}.path = [mappath,mapfunc];

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'ShimCalPol';
default{m,1}.entrystr = 'B0';
default{m,1}.options = {'B0','AbsFreq'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Plot';
default{m,1}.entrystr = 'Yes';
default{m,1}.options = {'No','Yes'};

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Map';
default{m,1}.labelstr = 'Map';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Create';