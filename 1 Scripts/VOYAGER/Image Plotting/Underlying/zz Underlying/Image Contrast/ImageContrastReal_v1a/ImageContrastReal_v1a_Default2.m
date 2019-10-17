%=========================================================
% 
%=========================================================

function [default] = ImageContrastReal_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Scale (min,max)';
default{m,1}.entrystr = '-1,1';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Colour';
default{m,1}.entrystr = 'No';
default{m,1}.options = {'Yes','No'};
