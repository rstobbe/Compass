%====================================================
%
%====================================================

function [default] = ZeroFill_ToDim_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ZFdims (x,y,z)';
default{m,1}.entrystr = '256,256,256';
