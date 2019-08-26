%=========================================================
% 
%=========================================================

function [default] = DiffImConsolD2N_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    loadpath = [SCRPTPATHS.rootloc,'Image Loading\Underlying\Selectable Functions\'];
elseif strcmp(filesep,'/')
end
loadfunc = 'LoadDWDicom_v1b';
addpath([loadpath,loadfunc]);

m = 1;
default{m,1}.entrytype = 'StatInput';
default{m,1}.labelstr = 'Image_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'LoadDWIDicom';
default{m,1}.entrystr = loadfunc;
default{m,1}.searchpath = loadpath;
default{m,1}.path = [loadpath,loadfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'LoadIm';
default{m,1}.labelstr = 'Consolidate';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';