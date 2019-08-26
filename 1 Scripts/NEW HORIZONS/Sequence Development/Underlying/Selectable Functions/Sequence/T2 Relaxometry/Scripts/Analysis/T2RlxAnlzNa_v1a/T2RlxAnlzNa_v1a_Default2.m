%=========================================================
% 
%=========================================================

function [default] = T2RlxAnlzNa_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'StatInput';
default{m,1}.labelstr = 'RlxAnlz_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'T2f (min:step:max)';
default{m,1}.entrystr = '1:0.5:2';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'T2s';
default{m,1}.entrystr = '29';

m = m+1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'RlxDes_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc1 = 'LoadMatFileCur_v4';
default{m,1}.(default{m,1}.runfunc1).curloc = SCRPTPATHS.outloc;
default{m,1}.runfunc2 = 'LoadMatFileDef_v4';
default{m,1}.(default{m,1}.runfunc2).defloc = SCRPTPATHS.outloc;
default{m,1}.searchpath = SCRPTPATHS.newhorizonsloc;
default{m,1}.path = SCRPTPATHS.newhorizonsloc;

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'N';
default{m,1}.entrystr = '10';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SMNR (min:step:max)';
default{m,1}.entrystr = '40:10:100';

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