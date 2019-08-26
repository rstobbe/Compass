%=========================================================
% 
%=========================================================

function [default] = CorrAbsNoise_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'sdv_noise';
default{m,1}.entrystr = '12.5';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'CorrInputImNum';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'CorrOutputImNum';
default{m,1}.entrystr = '2';

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.labelstr = 'Correct Images';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Correct';
default{m,1}.runfunc = 'CorrAbsNoise_v1a';
