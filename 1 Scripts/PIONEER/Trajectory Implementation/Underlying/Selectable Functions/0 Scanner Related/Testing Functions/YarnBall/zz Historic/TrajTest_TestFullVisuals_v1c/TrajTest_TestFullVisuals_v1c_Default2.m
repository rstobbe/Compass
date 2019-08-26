%=========================================================
% 
%=========================================================

function [default] = TrajTest_TestFullVisuals_v1c_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'FigureLoc';
default{m,1}.entrystr = 'Centre';
default{m,1}.options = {'Centre','Left','Right'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'TimAdj';
default{m,1}.entrystr = 'SingleCast';
default{m,1}.options = {'QuadCast','SingleCast'};