%=========================================================
% 
%=========================================================

function [default] = Plot_SDC_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'xAxis';
default{m,1}.entrystr = 'SampNum';
default{m,1}.options = {'SampNum','Rads'};

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Plot';
default{m,1}.labelstr = 'Plot';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';
