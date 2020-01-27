%=========================================================
% 
%=========================================================

function [default] = IntenseMaskRange_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ThreshBot';
default{m,1}.entrystr = '0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ThreshTop';
default{m,1}.entrystr = '1';
