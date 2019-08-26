%=========================================================
% 
%=========================================================

function [default] = RectPulseMT_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'w1 (rad/s)';
default{m,1}.entrystr = '100';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'deltaf (Hz)';
default{m,1}.entrystr = '1000';
