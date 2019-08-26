%====================================================
%
%====================================================

function [default] = ExportImage_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    loadpath = [SCRPTPATHS.voyagerloc,'Image Format Related\Underlying\Selectable Functions\Load\Mat\'];
    exportpath = [SCRPTPATHS.voyagerloc,'Image Format Related\Underlying\Selectable Functions\Export\Standard\'];
elseif strcmp(filesep,'/')
end
loadfunc = 'Im1LoadMat_v1a';
exportfunc = 'ExportImageAnlz_v1c';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Export_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'LoadImagefunc';
default{m,1}.entrystr = loadfunc;
default{m,1}.searchpath = loadpath;
default{m,1}.path = [loadpath,loadfunc];

m = m+1;
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

