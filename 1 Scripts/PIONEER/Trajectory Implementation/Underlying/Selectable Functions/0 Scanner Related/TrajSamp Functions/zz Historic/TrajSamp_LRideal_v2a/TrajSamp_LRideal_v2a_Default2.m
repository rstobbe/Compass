%=========================================================
% 
%=========================================================

function [default] = TrajSamp_LRideal_v2a_Default2(SCRPTPATHS)


m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'StartFrac';
default{m,1}.entrystr = '0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Dwell (ms)';
default{m,1}.entrystr = '0.002';