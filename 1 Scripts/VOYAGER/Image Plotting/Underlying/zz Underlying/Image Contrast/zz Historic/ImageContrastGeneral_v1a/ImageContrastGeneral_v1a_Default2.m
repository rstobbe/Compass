%=========================================================
% 
%=========================================================

function [default] = ImageContrastGeneral_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Scale (min,max)';
default{m,1}.entrystr = '-1,1';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Type';
default{m,1}.entrystr = 'real';
default{m,1}.options = {'real','imag','phase','abs'};

