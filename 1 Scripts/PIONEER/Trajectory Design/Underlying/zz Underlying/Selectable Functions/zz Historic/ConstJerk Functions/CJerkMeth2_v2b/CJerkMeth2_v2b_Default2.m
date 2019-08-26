%=========================================================
% 
%=========================================================

function [default] = CJerkMeth2_v2b_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Jrk_tc1 (ms)';
default{m,1}.entrystr = '0.0007';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Jrk_val1';
default{m,1}.entrystr = '2';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Jrk_tc2 (ms)';
default{m,1}.entrystr = '0.007';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Jrk_val2';
default{m,1}.entrystr = '2';
