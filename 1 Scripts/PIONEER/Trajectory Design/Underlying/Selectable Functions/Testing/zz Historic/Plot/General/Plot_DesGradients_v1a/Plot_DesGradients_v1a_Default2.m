%=========================================================
% 
%=========================================================

function [default] = Plot_DesGradients_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Gamma';
default{m,1}.entrystr = '42.577';

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Plot_Grad';
default{m,1}.labelstr = 'Plot_Grad';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Plot';