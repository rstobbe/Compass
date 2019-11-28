%=========================================================
% 
%=========================================================

function [default] = IntenseMaskValue_v1b_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Thresh';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Direction';
default{m,1}.entrystr = 'Positive';
default{m,1}.options = {'Positive','Negative'};