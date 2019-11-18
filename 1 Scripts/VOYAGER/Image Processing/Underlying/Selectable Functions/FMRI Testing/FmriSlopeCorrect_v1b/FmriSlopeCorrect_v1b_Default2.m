%=========================================================
% 
%=========================================================

function [default] = FmriSlopeCorrect_v1b_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RelOffset';
default{m,1}.entrystr = '1.05';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RelSlope';
default{m,1}.entrystr = '-0.0005';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RefMean';
default{m,1}.entrystr = '0.1';