%=========================================================
% 
%=========================================================

function [default] = Plot_SampTim_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TrajNum';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.labelstr = 'Plot';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Plot';
default{m,1}.runfunc = 'Plot_SampTim_v1a';