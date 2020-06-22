%====================================================
%
%====================================================

function [default] = ZeroFill_SelectionSS125_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'ZeroFill';
default{m,1}.entrystr = '100';
mat = (50:10:600).';
default{m,1}.options = mat2cell(mat,length(mat));
