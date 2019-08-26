%=========================================================
% 
%=========================================================

function [default] = LowPassFilterKaiser3D_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'kmax (1/m)';
default{m,1}.entrystr = '50';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'beta';
default{m,1}.entrystr = '6';

