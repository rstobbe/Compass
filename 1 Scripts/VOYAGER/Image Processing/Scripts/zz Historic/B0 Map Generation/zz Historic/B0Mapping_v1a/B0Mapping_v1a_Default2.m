%=========================================================
% 
%=========================================================

function [default] = B0Mapping_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    mappath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\B0 Field Mapping\Mapping\'];
    disppath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\B0 Field Mapping\Display\'];    
elseif strcmp(filesep,'/')
end
mapfunc = 'B0MapSingleRcvr_v1b';
addpath([mappath,mapfunc]);
dispfunc = 'DisplayB0Map_v1a';
addpath([disppath,dispfunc]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Image_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Load';
default{m,1}.entrystr = 'Local';
default{m,1}.options = {'Local','File'};

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Image_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'LoadImageCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadImageDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.searchpath = SCRPTPATHS.scrptshareloc;
default{m,1}.path = SCRPTPATHS.scrptshareloc;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'B0Mapfunc';
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