%=========================================================
% 
%=========================================================

function [default] = DeSolTim_TpiManual_v1e_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Fineness';
default{m,1}.entrystr = '2';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Shape';
default{m,1}.entrystr = '1';
