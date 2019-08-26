%=========================================================
% 
%=========================================================

function [default] = ReduceMatrixOffset_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'NewSize (LR,TB,IO)';
default{m,1}.entrystr = '100,100,100';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Offset (LR,TB,IO)';
default{m,1}.entrystr = '10,10,10';


