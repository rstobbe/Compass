%=========================================================
% 
%=========================================================

function [default] = Plot_TPIkSpace2Dproj_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Cones';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Clr';
default{m,1}.entrystr = 'k-';

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Plot';
default{m,1}.labelstr = 'Trajs';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Plot';