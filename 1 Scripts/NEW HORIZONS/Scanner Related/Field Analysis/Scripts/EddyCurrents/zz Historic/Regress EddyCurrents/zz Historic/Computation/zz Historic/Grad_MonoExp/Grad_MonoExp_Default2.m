%=========================================================
% 
%=========================================================

function [default] = Grad_MonoExp_Default2(scrptloc)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Grad_regstart (s)';
default{m,1}.entrystr = '0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Grad_regstop (s)';
default{m,1}.entrystr = '60';