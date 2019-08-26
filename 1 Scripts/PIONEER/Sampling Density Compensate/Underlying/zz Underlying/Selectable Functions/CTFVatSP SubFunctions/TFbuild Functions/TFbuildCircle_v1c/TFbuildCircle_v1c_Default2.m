%=========================================================
% 
%=========================================================

function [default] = TFbuildCircle_v1c_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MinRadDim';
default{m,1}.entrystr = '150';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MaxSubSamp';
default{m,1}.entrystr = '4';
