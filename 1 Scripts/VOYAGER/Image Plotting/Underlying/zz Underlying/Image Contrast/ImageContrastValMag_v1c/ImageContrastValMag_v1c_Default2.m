%=========================================================
% 
%=========================================================

function [default] = ImageContrastValMag_v1c_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MaxValue';
default{m,1}.entrystr = '100';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MinValue';
default{m,1}.entrystr = '0';