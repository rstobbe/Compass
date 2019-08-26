%=========================================================
% 
%=========================================================

function [default] = T2RlxDesNa_EvenTimeDist_v1a_Default2(SCRPTPATHS)

if strcmp(filesep,'\')
    gridpath = [SCRPTPATHS.voyagerloc,'Image Creation\Underlying\zz Underlying\Selectable Functions\kSpace Gridding\'];    
elseif strcmp(filesep,'/')
end
gridfunc = 'GridkSpace_Pioneer_v1c';
addpath([gridpath,gridfunc]);

m = 1;
default{m,1}.entrytype = 'StatInput';
default{m,1}.labelstr = 'RlxDes_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'T2f';
default{m,1}.entrystr = '2.9';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'T2s';
default{m,1}.entrystr = '29';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TEmin';
default{m,1}.entrystr = '0.3';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TEmax';
default{m,1}.entrystr = '20';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SMNR (min:step:max)';
default{m,1}.entrystr = '40:10:100';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'N (min,max)';
default{m,1}.entrystr = '5,12';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MonteCarlo';
default{m,1}.entrystr = '100';

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Grid_noSDC';
default{m,1}.labelstr = 'Run';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Grid';