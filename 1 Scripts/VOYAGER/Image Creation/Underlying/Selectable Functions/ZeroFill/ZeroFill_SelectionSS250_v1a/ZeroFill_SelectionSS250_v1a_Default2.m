%====================================================
%
%====================================================

function [default] = ZeroFill_SelectionSS250_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'ZeroFill';
default{m,1}.entrystr = '300';
mat = (300:10:900).';
default{m,1}.options = mat2cell(mat,length(mat));
