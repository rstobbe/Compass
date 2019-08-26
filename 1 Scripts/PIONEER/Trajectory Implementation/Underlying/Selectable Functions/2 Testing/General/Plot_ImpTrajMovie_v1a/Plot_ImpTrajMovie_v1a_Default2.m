%=========================================================
% 
%=========================================================

function [default] = Plot_TrajMovie_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RelRad';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Type';
default{m,1}.entrystr = 'AbsMax';
default{m,1}.options = {'AbsMax','RelMax','MatSteps'};

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Plot';
default{m,1}.labelstr = 'Plot_kSpace3D';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Plot';