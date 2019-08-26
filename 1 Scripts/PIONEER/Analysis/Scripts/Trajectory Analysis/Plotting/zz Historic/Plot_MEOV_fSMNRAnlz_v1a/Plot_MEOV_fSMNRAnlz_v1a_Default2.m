%=========================================================
% 
%=========================================================

function [default] = Plot_MEOV_ArrAnlz_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SNVR';
default{m,1}.entrystr = '0.234';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SMNR';
default{m,1}.entrystr = '40';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Colour';
default{m,1}.entrystr = 'r-';

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Plot';
default{m,1}.labelstr = 'Plot';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';
