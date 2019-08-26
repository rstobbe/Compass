%=========================================================
% 
%=========================================================

function [default] = RelMapping_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    loadpath = [SCRPTPATHS.voyagerloc,'Image Format Related\Underlying\Selectable Functions\Load\Mat\'];
    algnpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Image Registration\ReSize\'];
    mappath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Relative Mapping\Mapping\'];
    disppath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Image Display\'];    
elseif strcmp(filesep,'/')
end
loadfunc = 'ImMultiLoadGeneric_v1a';
addpath([loadpath,loadfunc]);
algnfunc = 'SameSizeTest_v1a';
addpath([algnpath,algnfunc]);
mapfunc = 'RatioImage_v1a';
addpath([mappath,mapfunc]);
dispfunc = 'SubPlotMontage_v1a';
addpath([disppath,dispfunc]);

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
default{m,1}.labelstr = 'ReSizefunc';
default{m,1}.entrystr = algnfunc;
default{m,1}.searchpath = algnpath;
default{m,1}.path = [algnpath,algnfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Mapfunc';
default{m,1}.entrystr = mapfunc;
default{m,1}.searchpath = mappath;
default{m,1}.path = [mappath,mapfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Dispfunc';
default{m,1}.entrystr = dispfunc;
default{m,1}.searchpath = disppath;
default{m,1}.path = [disppath,dispfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Map';
default{m,1}.labelstr = 'Map';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';