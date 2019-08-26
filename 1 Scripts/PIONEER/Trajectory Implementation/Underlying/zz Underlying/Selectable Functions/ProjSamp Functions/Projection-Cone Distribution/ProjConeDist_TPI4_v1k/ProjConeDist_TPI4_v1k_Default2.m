%=========================================================
% 
%=========================================================

function [default] = ProjConeDist_TPI4_v1k_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ThetaRateInc (o,N)';
default{m,1}.entrystr = '15,1.1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'PhiRateInc';
default{m,1}.entrystr = '1.1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Phi(0)_Theta(1)';
default{m,1}.entrystr = '1';
