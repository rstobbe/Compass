%====================================================
%
%====================================================

function [default] = R2Smap_TEarr_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    calcpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\zz Underlying\Selectable Functions\Relaxation Mapping\'];
elseif strcmp(filesep,'/')
end
calcfunc = 'R2Smap_v1b';
addpath([calcpath,calcfunc]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RelMaskVal';
default{m,1}.entrystr = '0.3';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Calcfunc';
default{m,1}.entrystr = calcfunc;
default{m,1}.searchpath = calcpath;
default{m,1}.path = [calcpath,calcfunc];

