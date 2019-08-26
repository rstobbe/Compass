%=========================================================
% 
%=========================================================

function [default] = Spin_SportWeight_v1b_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'PolSampFact';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'AziSampFact';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'ForceOddSpokes';
default{m,1}.entrystr = 'Yes';
default{m,1}.options = {'Yes','No'};
