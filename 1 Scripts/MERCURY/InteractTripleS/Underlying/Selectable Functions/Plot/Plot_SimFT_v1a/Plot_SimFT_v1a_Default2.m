%=========================================================
% 
%=========================================================

function [default] = Plot_SimFT_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'YLim';
default{m,1}.entrystr = '-100 100';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'FigSize (inches)';
default{m,1}.entrystr = '3.5 3';
