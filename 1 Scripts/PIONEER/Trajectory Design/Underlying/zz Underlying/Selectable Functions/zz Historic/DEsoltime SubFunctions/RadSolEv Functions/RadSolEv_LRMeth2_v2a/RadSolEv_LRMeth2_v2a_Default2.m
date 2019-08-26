%=========================================================
% 
%=========================================================

function [default] = RadSolEv_LRMeth2_v2a_Default2(~)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Nin';
default{m,1}.entrystr = '2000';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'OutShape';
default{m,1}.entrystr = '0.5';

