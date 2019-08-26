%=========================================================
% 
%=========================================================

function [default] = GenMapFigure_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Scale (min,max)';
default{m,1}.entrystr = '0,1';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Colour';
default{m,1}.entrystr = 'Yes';
default{m,1}.options = {'No','Yes'};
