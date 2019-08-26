%=========================================================
% 
%=========================================================

function [default] = ReduceMatrixSpecify_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'LeftRight';
default{m,1}.entrystr = '0:0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TopBot';
default{m,1}.entrystr = '0:0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'InOut';
default{m,1}.entrystr = '0:0';