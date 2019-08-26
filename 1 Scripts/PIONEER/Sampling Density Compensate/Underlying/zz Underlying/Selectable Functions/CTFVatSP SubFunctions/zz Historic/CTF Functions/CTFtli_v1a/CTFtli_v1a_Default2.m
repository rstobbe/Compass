%=========================================================
% 
%=========================================================

function [default] = CTFtli_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MinRadDim';
default{m,1}.entrystr = '80';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MaxSubSamp';
default{m,1}.entrystr = '4';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'CTFscale';
default{m,1}.entrystr = 'Standard';
default{m,1}.options = {'Standard','CentreVal1','includeOS'};