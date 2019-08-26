%=========================================================
% 
%=========================================================

function [default] = CTF_Sphere_v1c_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MinRadDim';
default{m,1}.entrystr = '80';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MaxSubSamp';
default{m,1}.entrystr = '4';