%=========================================================
% 
%=========================================================

function [default] = CGMaskIntensity_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RelIntensity';
default{m,1}.entrystr = '0.1';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Test';
default{m,1}.entrystr = 'Yes';
default{m,1}.options = {'No','Yes'};
