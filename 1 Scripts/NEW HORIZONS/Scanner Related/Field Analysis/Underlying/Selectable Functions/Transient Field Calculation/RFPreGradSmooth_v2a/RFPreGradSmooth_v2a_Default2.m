%====================================================
%
%====================================================

function [default] = RFPreGradSmooth_v2a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SmoothFraction';
default{m,1}.entrystr = '0.1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SmoothFactor';
default{m,1}.entrystr = '0.1';
