%=========================================================
% 
%=========================================================

function [default] = MotCorMSYB_v1a_Default2(SCRPTPATHS)

SCRPTPATHS.Vrootloc = 'D:\1 Scripts\VOYAGER\Set 1.1\';
if strcmp(filesep,'\')
    gridpath = [SCRPTPATHS.Vrootloc,'Image Creation\Underlying\zz Underlying\Selectable Functions\kSpace Gridding\'];    
elseif strcmp(filesep,'/')
end
gridfunc = 'GridkSpace_Pioneer_v1b';
addpath([gridpath,gridfunc]);

m = 1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Gridfunc';
default{m,1}.entrystr = gridfunc;
default{m,1}.searchpath = gridpath;
default{m,1}.path = [gridpath,gridfunc];

