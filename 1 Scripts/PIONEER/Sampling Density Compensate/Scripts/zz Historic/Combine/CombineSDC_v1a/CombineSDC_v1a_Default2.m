%====================================================
%
%====================================================

function [default] = CombineSDC_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    loadpath = [SCRPTPATHS.scrptshareloc,'0 General\File Related\Selectable Functions\'];
elseif strcmp(filesep,'/')
end
loadfunc = 'MultiFileLoad_v1a';
addpath([loadpath,loadfunc]);

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SDC_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'LoadSDCfunc';
default{m,1}.entrystr = loadfunc;
default{m,1}.searchpath = loadpath;
default{m,1}.path = [loadpath,loadfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Load';
default{m,1}.labelstr = 'Load';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';

