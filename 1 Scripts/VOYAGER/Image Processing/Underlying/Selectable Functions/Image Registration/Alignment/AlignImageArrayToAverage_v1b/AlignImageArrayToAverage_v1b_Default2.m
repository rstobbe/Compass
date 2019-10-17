%=========================================================
% 
%=========================================================

function [default] = AlignMultiImagesToAverage_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Pass1AlignIm';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Average';
default{m,1}.entrystr = 'Abs';
default{m,1}.options = {'Complex','Abs'};