%=========================================================
% 
%=========================================================

function [default] = PixelCorrelationInROI_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'XFigNum';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'YFigNum';
default{m,1}.entrystr = '2';

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.labelstr = 'Plot Correlation';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Calculate';
default{m,1}.runfunc = 'PixelCorrelationInROI_v1a';
