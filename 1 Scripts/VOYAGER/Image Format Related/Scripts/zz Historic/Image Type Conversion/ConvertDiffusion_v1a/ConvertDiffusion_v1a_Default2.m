%=========================================================
% 
%=========================================================

function [default] = ConvertDiffusion_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    loadpath = [SCRPTPATHS.voyagerloc,'Image Format Related\Underlying\Selectable Functions\Load\Diffusion\'];
    exportpath = [SCRPTPATHS.voyagerloc,'Image Format Related\Underlying\Selectable Functions\Export\Diffusion\'];
elseif strcmp(filesep,'/')
end
loadfunc = 'LoadDiffImNiftiAveB0_v1a';
exportfunc = 'ExportDiffImMat_v1a';
addpath([loadpath,loadfunc]);
addpath([exportpath,exportfunc]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Image_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'LoadDWIfunc';
default{m,1}.entrystr = loadfunc;
default{m,1}.searchpath = loadpath;
default{m,1}.path = [loadpath,loadfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ExportDWIfunc';
default{m,1}.entrystr = exportfunc;
default{m,1}.searchpath = exportpath;
default{m,1}.path = [exportpath,exportfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'ExportIm';
default{m,1}.labelstr = 'Convert';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';