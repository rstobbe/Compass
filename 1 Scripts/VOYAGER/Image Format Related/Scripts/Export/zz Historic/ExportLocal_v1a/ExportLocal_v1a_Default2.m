%====================================================
%
%====================================================

function [default] = ExportLocal_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    exportpath = [SCRPTPATHS.voyagerloc,'Image Format Related\Underlying\Selectable Functions\Export\Standard\'];
elseif strcmp(filesep,'/')
end
exportfunc = 'ExportImageNII_v1a';
addpath([exportpath,exportfunc]);

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ExportImagefunc';
default{m,1}.entrystr = exportfunc;
default{m,1}.searchpath = exportpath;
default{m,1}.path = [exportpath,exportfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Export';
default{m,1}.labelstr = 'Export';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';

