%=========================================================
% 
%=========================================================

function [default] = ImageContrastRelSelect_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MaxRelVal';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Type';
default{m,1}.entrystr = 'abs';
default{m,1}.options = {'real','imag','phase','abs'};