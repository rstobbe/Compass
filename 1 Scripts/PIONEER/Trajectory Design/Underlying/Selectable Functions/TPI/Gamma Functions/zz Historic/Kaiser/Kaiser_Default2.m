%=========================================================
% 
%=========================================================

function [default] = Kaiser_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Beta';
default{m,1}.entrystr = 4;

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'GamFunc Vis';
default{m,1}.entrystr = 'Off';
default{m,1}.options = {'On','Off'};