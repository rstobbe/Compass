%=========================================================
% 
%=========================================================

function [default] = RotCorMSYB_v1a_Default2(SCRPTPATHS)

relthresh = '0.2';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RelThresh';
default{m,1}.entrystr = relthresh;