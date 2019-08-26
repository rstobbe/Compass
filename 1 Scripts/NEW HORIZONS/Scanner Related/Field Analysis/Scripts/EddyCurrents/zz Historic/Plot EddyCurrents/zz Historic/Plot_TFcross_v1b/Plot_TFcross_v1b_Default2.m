%=========================================================
% 
%=========================================================

function [default] = Plot_TFcross_v1b_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Colour';
default{m,1}.entrystr = 'k';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Cross';
default{m,1}.entrystr = '12->AB';
default{m,1}.options = {'12->AB','AB->12'};

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Plot_Eddy';
default{m,1}.labelstr = 'Plot_TF';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Plot';