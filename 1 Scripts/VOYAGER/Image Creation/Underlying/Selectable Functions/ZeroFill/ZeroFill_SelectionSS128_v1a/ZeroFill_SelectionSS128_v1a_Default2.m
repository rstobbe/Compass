%====================================================
%
%====================================================

function [default] = ZeroFill_SelectionSS128_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'ZeroFill';
default{m,1}.entrystr = '64';
default{m,1}.options = {'512','576','640','704','768'};
