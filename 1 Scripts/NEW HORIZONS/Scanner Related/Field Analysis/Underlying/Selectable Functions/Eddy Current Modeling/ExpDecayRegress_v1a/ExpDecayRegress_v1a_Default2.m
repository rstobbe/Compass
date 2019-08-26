%=========================================================
% 
%=========================================================

function [default] = ExpDecayRegress_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Tc Estimate (ms)';
default{m,1}.entrystr = '0.06';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Mag Estimate (%)';
default{m,1}.entrystr = '10';

