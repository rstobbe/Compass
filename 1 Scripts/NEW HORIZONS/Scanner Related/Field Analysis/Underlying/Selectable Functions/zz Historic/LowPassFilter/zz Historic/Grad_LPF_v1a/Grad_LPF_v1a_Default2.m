%=========================================================
% 
%=========================================================

function [default] = Grad_LPF_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Grad_cutoff (Hz)';
default{m,1}.entrystr = '600';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Grad_FT Vis';
default{m,1}.entrystr = 'Off';
default{m,1}.options = {'On','Off'};