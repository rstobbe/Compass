%=========================================================
% 
%=========================================================

function [default] = Grid_noSDC_TrjSel_v1b_Default2(SCRPTPATHS)

SCRPTPATHS.Vrootloc = 'D:\1 Scripts\VOYAGER\Set 1.1\';
if strcmp(filesep,'\')
    gridpath = [SCRPTPATHS.Vrootloc,'Image Creation\Underlying\zz Underlying\Selectable Functions\kSpace Gridding\'];    
elseif strcmp(filesep,'/')
end
gridfunc = 'GridkSpace_Pioneer_v1a';
addpath([gridpath,gridfunc]);

traj = '1';

m = 1;
default{m,1}.entrytype = 'StatInput';
default{m,1}.labelstr = 'Grid_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Imp_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc1 = 'LoadTrajImpCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc1).loadpanel = 'Yes';
default{m,1}.runfunc2 = 'LoadTrajImpDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.(default{m,1}.runfunc2).loadpanel = 'Yes';
default{m,1}.searchpath = SCRPTPATHS.rootloc;
default{m,1}.path = SCRPTPATHS.rootloc;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Traj';
default{m,1}.entrystr = traj;

m = m+1;
default{m,1}.entrytype = 'ScrptFunc';
default{m,1}.labelstr = 'Gridfunc';
default{m,1}.entrystr = gridfunc;
default{m,1}.searchpath = gridpath;
default{m,1}.path = [gridpath,gridfunc];

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Grid_noSDC';
default{m,1}.labelstr = 'Run';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Grid';