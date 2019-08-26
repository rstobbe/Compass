%====================================================
%
%====================================================

function [default] = B1MapAFISiemensBodyRx_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Mask (relval)';
default{m,1}.entrystr = '0.1';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Output';
default{m,1}.entrystr = 'MapWithHist';
default{m,1}.options = {'Compass','CompassMontage','MapWithHist'};