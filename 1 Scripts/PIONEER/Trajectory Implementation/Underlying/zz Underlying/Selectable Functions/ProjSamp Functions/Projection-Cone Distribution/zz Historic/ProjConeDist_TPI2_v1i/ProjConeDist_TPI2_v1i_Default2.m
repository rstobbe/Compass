%=========================================================
% 
%=========================================================

function [default] = ProjConeDist_TPI2_v1i_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ExtraProj (o,num)';
default{m,1}.entrystr = '25,5';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MaxRelConeOS';
default{m,1}.entrystr = '1.3';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Phi(0)_Theta(1)';
default{m,1}.entrystr = '0.9';
