%=========================================================
% 
%=========================================================

function [default] = T1_CNRopt_v1b_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TRmark (ms)';
default{m,1}.entrystr = '15';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Flipmark (ms)';
default{m,1}.entrystr = '16';