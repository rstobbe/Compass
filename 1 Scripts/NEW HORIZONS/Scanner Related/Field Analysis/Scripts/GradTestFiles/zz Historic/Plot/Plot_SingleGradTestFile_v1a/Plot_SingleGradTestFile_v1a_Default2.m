%=========================================================
% 
%=========================================================

function [default] = Plot_GradTestFile_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Colour';
default{m,1}.entrystr = 'k-';

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Plot_Grad';
default{m,1}.labelstr = 'Plot_Grad';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Plot';