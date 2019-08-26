%=========================================================
% 
%=========================================================

function [default] = Calc2KurtIM_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.labelstr = 'Calculate Kurtosis';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Calculate';
default{m,1}.runfunc = 'Calc2KurtIM_v1a';
