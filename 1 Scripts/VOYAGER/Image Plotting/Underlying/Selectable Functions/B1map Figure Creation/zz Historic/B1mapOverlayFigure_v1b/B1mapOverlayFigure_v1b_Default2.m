%=========================================================
% 
%=========================================================

function [default] = B1mapOverlayFigure_v1b_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Scale (min,max)';
default{m,1}.entrystr = '0.8,1.2';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Type';
default{m,1}.entrystr = 'Linear';
default{m,1}.options = {'Linear','dB'};