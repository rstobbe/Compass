%=========================================================
% 
%=========================================================

function [default] = CTFgrid_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TFRadDim';
default{m,1}.entrystr = '50';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'CTFscale';
default{m,1}.entrystr = 'Standard';
default{m,1}.options = {'Standard','CentreVal1','includeOS'};