%=========================================================
% 
%=========================================================

function [default] = FullySampleCentre_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'FullSampMatrixDiam';
default{m,1}.entrystr = '5.0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'OSCfactor';
default{m,1}.entrystr = '1.0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'USfactor';
default{m,1}.entrystr = '1.0';
