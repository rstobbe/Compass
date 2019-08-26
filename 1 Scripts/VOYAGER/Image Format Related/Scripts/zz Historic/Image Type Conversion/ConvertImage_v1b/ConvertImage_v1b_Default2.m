%====================================================
%
%====================================================

function [default] = ConvertImage_v1b_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    loadpath = [SCRPTPATHS.voyagerloc,'Image Format Related\Underlying\Selectable Functions\Load'];
    exportpath = [SCRPTPATHS.voyagerloc,'Image Format Related\Underlying\Selectable Functions\Export\'];
elseif strcmp(filesep,'/')
end
loadfunc = 'LoadDiffImNiftiAveB0_v1a';
exportfunc = 'ExportDiffImMat_v1a';
addpath([loadpath,loadfunc]);
addpath([exportpath,exportfunc]);

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Loadfunc';
default{m,1}.entrystr = loadfunc;
default{m,1}.searchpath = loadpath;
default{m,1}.path = [loadpath,loadfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Exportfunc';
default{m,1}.entrystr = exportfunc;
default{m,1}.searchpath = exportpath;
default{m,1}.path = [exportpath,exportfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'ConvertIm';
default{m,1}.labelstr = 'Convert';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';

