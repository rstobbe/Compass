%=========================================================
% 
%=========================================================

function [default] = Study_MS_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    selectpath = [SCRPTPATHS.scrptshareloc,'0 General\File Related\Selectable Functions\'];
elseif strcmp(filesep,'/')
end

selectfunc = 'MultiGenericFileSelect_v1a';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Study_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'ExcelSelectfunc';
default{m,1}.entrystr = selectfunc;
default{m,1}.searchpath = selectpath;
default{m,1}.path = [selectpath,selectfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'build';
default{m,1}.labelstr = 'Build';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Build';
