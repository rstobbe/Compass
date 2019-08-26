%=========================================================
% 
%=========================================================

function [default] = Spin_PlusGaussian_v2a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'CenSampFact';
default{m,1}.entrystr = '1.2';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Beta';
default{m,1}.entrystr = '12';

