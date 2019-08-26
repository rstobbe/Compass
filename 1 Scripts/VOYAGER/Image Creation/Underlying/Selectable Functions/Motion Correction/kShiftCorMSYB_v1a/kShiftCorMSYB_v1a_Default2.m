%=========================================================
% 
%=========================================================

function [default] = kShiftCorMSYB_v1a_Default2(SCRPTPATHS)

SCRPTPATHS.Vrootloc = 'D:\1 Scripts\VOYAGER\Set 1.1\';
if strcmp(filesep,'\')
    gridpath = [SCRPTPATHS.Vrootloc,'Image Creation\Underlying\zz Underlying\Selectable Functions\kSpace Gridding\'];    
    kshftcorpath = [SCRPTPATHS.Vrootloc,'Image Creation\Underlying\zz Underlying\Selectable Functions\Motion Correction Regression\'];   
elseif strcmp(filesep,'/')
end
gridfunc = 'GridkSpace_SubSampSel_v1a';
kshftcorfunc = 'kShiftCorReg_v1a';
addpath([gridpath,gridfunc]);
addpath([kshftcorpath,kshftcorfunc]);

trajmax = '4.5';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TrajMax (kstps)';
default{m,1}.entrystr = trajmax;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Gridfunc';
default{m,1}.entrystr = gridfunc;
default{m,1}.searchpath = gridpath;
default{m,1}.path = [gridpath,gridfunc];

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'kShftCorfunc';
default{m,1}.entrystr = kshftcorfunc;
default{m,1}.searchpath = kshftcorpath;
default{m,1}.path = [kshftcorpath,kshftcorfunc];

