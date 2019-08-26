%=========================================================
% 
%=========================================================

function [default] = FixedSphere_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'FoV (mm)';
default{m,1}.entrystr = '30';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Diam (mm)';
default{m,1}.entrystr = '10';


