%=========================================================
% 
%=========================================================

function [default] = Grad_MonoExp_v2a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Grad_regstart (ms)';
default{m,1}.entrystr = '0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Grad_regstop (ms)';
default{m,1}.entrystr = '100';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Grad_start (ms)';
default{m,1}.entrystr = '0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Grad_est (ms)';
default{m,1}.entrystr = '0';