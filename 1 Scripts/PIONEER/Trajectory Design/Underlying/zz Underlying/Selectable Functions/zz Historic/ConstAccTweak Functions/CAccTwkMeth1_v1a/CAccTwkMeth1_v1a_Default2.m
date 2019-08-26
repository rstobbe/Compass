%=========================================================
% 
%=========================================================

function [default] = CAccTwkMeth1_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Twk_tc1 (ms)';
default{m,1}.entrystr = '0.01';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Twk_val1';
default{m,1}.entrystr = '-3';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Twk_tc2 (ms)';
default{m,1}.entrystr = '0.001';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Twk_val2';
default{m,1}.entrystr = '-3.5';
