%====================================================
%
%====================================================

function [default] = DCcorPA_TrlFid_v1e_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TrlFid (%)';
default{m,1}.entrystr = '10';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Method';
default{m,1}.entrystr = 'Mean';
default{m,1}.options = {'Mean','Individual'};