%=========================================================
% 
%=========================================================

function [default] = USA_Uniform_v2a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'USIfactor';
default{m,1}.entrystr = '1.0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'USAfactor';
default{m,1}.entrystr = '1.0';
