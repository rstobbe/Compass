%=========================================================
% 
%=========================================================

function [default] = Spin_FullySampleCentre_v1b_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'FullSampMatDiam';
default{m,1}.entrystr = '5.0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'CentSampFactor';
default{m,1}.entrystr = '1.0';

