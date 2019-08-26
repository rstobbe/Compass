%=========================================================
% 
%=========================================================

function [default] = GreyWhiteT1_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GreyT1 (ms)';
default{m,1}.entrystr = '1330';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'WhiteT1 (ms)';
default{m,1}.entrystr = '830';

