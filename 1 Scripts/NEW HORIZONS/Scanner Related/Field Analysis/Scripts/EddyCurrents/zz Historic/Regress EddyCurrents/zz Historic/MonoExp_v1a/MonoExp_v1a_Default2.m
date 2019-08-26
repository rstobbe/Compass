%=========================================================
% 
%=========================================================

function [default] = MonoExp_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'StatInput';
default{m,1}.labelstr = 'Rgrs_Name';
default{m,1}.entrystr = '';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Figure Number';
default{m,1}.entrystr = '2000';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SelectEddy';
default{m,1}.entrystr = 'B0eddy';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'DataStart (ms)';
default{m,1}.entrystr = '0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'DataStop (ms)';
default{m,1}.entrystr = '10';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TimePastG (ms)';
default{m,1}.entrystr = 'na';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Tc Estimate (ms)';
default{m,1}.entrystr = '2';

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Regression';
default{m,1}.labelstr = 'Regression';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';