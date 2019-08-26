%=========================================================
% 
%=========================================================

function [default] = Plot_Eddy_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Colour';
default{m,1}.entrystr = 'k-';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Type';
default{m,1}.entrystr = 'Abs';
default{m,1}.options = {'Percent','Abs'};

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Plot_Eddy';
default{m,1}.labelstr = 'Plot_Eddies';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Plot';