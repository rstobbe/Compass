%=========================================================
% 
%=========================================================

function [default] = CreateB0Map_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Threshold';
default{m,1}.entrystr = '0.05';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MaxDisp (Hz)';
default{m,1}.entrystr = '40';

