%=========================================================
% 
%=========================================================

function [default] = ImageContrastRelMag_v1c_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MaxRelVal';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MinRelVal';
default{m,1}.entrystr = '0';