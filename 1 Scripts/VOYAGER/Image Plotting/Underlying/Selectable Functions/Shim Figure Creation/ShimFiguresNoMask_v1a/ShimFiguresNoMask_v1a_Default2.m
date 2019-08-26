%=========================================================
% 
%=========================================================

function [default] = ShimFiguresNoMask_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Disp (Hz)';
default{m,1}.entrystr = 'Full';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'HistStep (Hz)';
default{m,1}.entrystr = 1;
