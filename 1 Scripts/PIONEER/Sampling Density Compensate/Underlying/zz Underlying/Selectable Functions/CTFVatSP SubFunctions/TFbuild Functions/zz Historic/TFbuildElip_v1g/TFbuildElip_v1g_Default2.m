%=========================================================
% 
%=========================================================

function [default] = TFbuildElip_v1g_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MinRadDim';
default{m,1}.entrystr = '100';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MinSubSamp';
default{m,1}.entrystr = '1';
