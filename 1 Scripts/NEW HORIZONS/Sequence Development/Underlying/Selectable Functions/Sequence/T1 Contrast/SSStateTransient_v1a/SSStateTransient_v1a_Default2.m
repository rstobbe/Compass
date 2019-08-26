%=========================================================
% 
%=========================================================

function [default] = SSStateTransient_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TR (ms)';
default{m,1}.entrystr = '11';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Flip (ms)';
default{m,1}.entrystr = '14';