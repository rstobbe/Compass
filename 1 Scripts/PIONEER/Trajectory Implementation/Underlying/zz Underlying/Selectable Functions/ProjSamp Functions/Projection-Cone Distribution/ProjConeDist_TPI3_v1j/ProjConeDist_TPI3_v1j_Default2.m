%=========================================================
% 
%=========================================================

function [default] = ProjConeDist_TPI3_v1j_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ExtraProj (o,N)';
default{m,1}.entrystr = '15,3';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MaxRelConeEP';
default{m,1}.entrystr = '1.3';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'PhiRateInc (o,N)';
default{m,1}.entrystr = '15,1.2';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Phi(0)_Theta(1)';
default{m,1}.entrystr = '0.5';
