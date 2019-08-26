%====================================================
%
%====================================================

function [default] = DataOrg_LowSubTimeSeries_v1c_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TrajPerIm';
default{m,1}.entrystr = '100';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'kmaxRel (%)';
default{m,1}.entrystr = '50';