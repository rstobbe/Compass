%=========================================================
% 
%=========================================================

function [default] = ConcScale_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'CurrentValue';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'AssignValue';
default{m,1}.entrystr = '1';