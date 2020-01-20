%=========================================================
% 
%=========================================================

function [default] = CalcKurtROI_v2a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'CalcImNum';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'CalcFigNum';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'CalcROINum';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.labelstr = 'Calculate Kurtosis';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Calculate';
default{m,1}.runfunc = 'CalcKurtROI_v2a';
