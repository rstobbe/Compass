%====================================================
%
%====================================================

function [default] = DCcorPA_Med_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Method';
default{m,1}.entrystr = 'Mean';
default{m,1}.options = {'Mean','Individual'};