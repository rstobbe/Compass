%====================================================
%
%====================================================

function [default] = PostProc_MSYBMTF_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    fatpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\Fat Suppression\'];
    mtpath = [SCRPTPATHS.voyagerloc,'Image Processing\Underlying\Selectable Functions\MT Mapping\'];
elseif strcmp(filesep,'/')
end
fatfunc = 'Dixon_v1a';
addpath([fatpath,fatfunc]);
mtfunc = 'rMTmap_v1a';
addpath([mtpath,mtfunc]);

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'FatSupressfunc';
default{m,1}.entrystr = fatfunc;
default{m,1}.searchpath = fatpath;
default{m,1}.path = [fatpath,fatfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'MTfunc';
default{m,1}.entrystr = mtfunc;
default{m,1}.searchpath = mtpath;
default{m,1}.path = [mtpath,mtfunc];