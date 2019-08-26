%=========================================================
% 
%=========================================================

function [default] = Calc2KurtIM_v3a_testing_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MinVal_b0';
default{m,1}.entrystr = '60';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'CalcImNum';
default{m,1}.entrystr = '2';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MKmapImNum';
default{m,1}.entrystr = '3';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MDmapImNum';
default{m,1}.entrystr = '4';

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.labelstr = 'Calculate Kurtosis';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Calculate';
default{m,1}.runfunc = 'Calc2KurtIM_v3a_testing';
