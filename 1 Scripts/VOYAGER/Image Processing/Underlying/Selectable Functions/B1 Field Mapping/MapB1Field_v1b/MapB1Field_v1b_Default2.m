%====================================================
%
%====================================================

function [default] = MapB1Field_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    mappath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\zz Underlying\Selectable Functions\B1 Field Mapping\Mapping\'];
    baseimpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Base Image for Mapping\'];
elseif strcmp(filesep,'/')
end
mapfunc = 'B1MapSingleRcvr_v2b';
baseimfunc = 'AbsCombine_v1a';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'BaseImfunc';
default{m,1}.entrystr = baseimfunc;
default{m,1}.searchpath = baseimpath;
default{m,1}.path = [baseimpath,baseimfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'B1Mapfunc';
default{m,1}.entrystr = mapfunc;
default{m,1}.searchpath = mappath;
default{m,1}.path = [mappath,mapfunc];

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Return';
default{m,1}.entrystr = 'B1';
default{m,1}.options = {'B1','Power'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Output';
default{m,1}.entrystr = 'Map';
default{m,1}.options = {'Map','Map+Base'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Plot';
default{m,1}.entrystr = 'Yes';
default{m,1}.options = {'No','Yes'};
