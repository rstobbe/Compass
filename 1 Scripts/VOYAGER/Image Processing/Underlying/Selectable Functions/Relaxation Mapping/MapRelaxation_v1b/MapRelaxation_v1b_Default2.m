%====================================================
%
%====================================================

function [default] = MapRelaxation_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    mappath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\zz Underlying\Selectable Functions\Relaxation Mapping\'];
    baseimpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\zz Underlying\Selectable Functions\Base Image for Mapping\'];
elseif strcmp(filesep,'/')
end
mapfunc = 'T2sMono2ImEst_v1c';
baseimfunc = 'FirstImage_v1a';

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'BaseImfunc';
default{m,1}.entrystr = baseimfunc;
default{m,1}.searchpath = baseimpath;
default{m,1}.path = [baseimpath,baseimfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'RelaxMapfunc';
default{m,1}.entrystr = mapfunc;
default{m,1}.searchpath = mappath;
default{m,1}.path = [mappath,mapfunc];