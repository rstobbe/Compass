%=========================================================
% 
%=========================================================

function [default] = B0mapOverlayFigure_v1b_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Scale (min,max)';
default{m,1}.entrystr = '-100,100';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Histogram';
default{m,1}.entrystr = 'Yes';
default{m,1}.options = {'No','Yes'};

