%=========================================================
% 
%=========================================================

function [default] = Plot_T2RlxDesNa_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'PI (%)';
default{m,1}.entrystr = '10';

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Plot';
default{m,1}.labelstr = 'Plot';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';
