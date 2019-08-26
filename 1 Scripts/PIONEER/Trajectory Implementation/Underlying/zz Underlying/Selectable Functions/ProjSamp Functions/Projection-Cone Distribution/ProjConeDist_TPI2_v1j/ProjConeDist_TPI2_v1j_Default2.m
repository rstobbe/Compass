%=========================================================
% 
%=========================================================

function [default] = ProjConeDist_TPI2_v1j_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ExtraProj (o,rel)';
default{m,1}.entrystr = '20,1.25';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Phi(0)_Theta(1)';
default{m,1}.entrystr = '0.5';
