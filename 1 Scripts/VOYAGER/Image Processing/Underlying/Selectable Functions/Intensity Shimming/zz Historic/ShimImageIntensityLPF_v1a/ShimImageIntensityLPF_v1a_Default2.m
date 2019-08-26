%=========================================================
% 
%=========================================================

function [default] = ShimImageIntensityLPF_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ImProfRes (mm)';
default{m,1}.entrystr = '10';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ImProfFilt (beta)';
default{m,1}.entrystr = '12';


