%====================================================
%
%====================================================

function [default] = ZeroFill_SelectionSS160_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'ZeroFill';
default{m,1}.entrystr = '64';
mat = (64:16:1000).';
default{m,1}.options = mat2cell(mat,length(mat));
