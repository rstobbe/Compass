%=========================================================
% 
%=========================================================

function [default] = T1_SNRoptMaxWgt_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TRmark (ms)';
default{m,1}.entrystr = '3';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Flipmark (deg)';
default{m,1}.entrystr = '1';