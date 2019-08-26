%=========================================================
% 
%=========================================================

function [default] = DeSolTim_TpiManual_v1d_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Fineness';
default{m,1}.entrystr = '10';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Shape';
default{m,1}.entrystr = '2';
