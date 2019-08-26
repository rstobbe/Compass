%=========================================================
% 
%=========================================================

function [default] = pad2a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Randomizer';
default{m,1}.entrystr = '71';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'ProjAngleDist Vis';
default{m,1}.entrystr = 'Off';
default{m,1}.options = {'On','Off'};