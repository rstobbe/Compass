%=========================================================
% 
%=========================================================

function [default] = Plot_ImpkSpace3DMultiEchoSelect_v1d_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TrajNum';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'EchoNum';
default{m,1}.entrystr = '1';