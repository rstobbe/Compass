%=========================================================
% 
%=========================================================

function [default] = DeSolTim_TpiManual_v1b_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Nin';
default{m,1}.entrystr = '500';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'OutShape';
default{m,1}.entrystr = '5';
