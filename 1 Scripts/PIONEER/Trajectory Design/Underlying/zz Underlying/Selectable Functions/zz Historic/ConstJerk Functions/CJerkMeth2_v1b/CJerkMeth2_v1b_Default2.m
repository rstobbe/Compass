%=========================================================
% 
%=========================================================

function [default] = CJerkMeth2_v1b_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Jrk_tc (ms)';
default{m,1}.entrystr = '0.007';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Jrk_val';
default{m,1}.entrystr = '2';
