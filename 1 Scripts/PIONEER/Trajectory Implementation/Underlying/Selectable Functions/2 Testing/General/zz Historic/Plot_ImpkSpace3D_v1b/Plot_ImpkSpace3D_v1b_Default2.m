%=========================================================
% 
%=========================================================

function [default] = Plot_ImpkSpace3D_v1b_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TrajNum';
default{m,1}.entrystr = 'Multi';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RelRad';
default{m,1}.entrystr = '0.1';

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Plot';
default{m,1}.labelstr = 'Plot';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';
