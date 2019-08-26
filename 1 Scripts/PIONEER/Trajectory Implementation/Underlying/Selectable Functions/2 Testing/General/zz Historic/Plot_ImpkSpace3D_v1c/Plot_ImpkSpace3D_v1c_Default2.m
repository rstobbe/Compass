%=========================================================
% 
%=========================================================

function [default] = Plot_ImpkSpace3D_v1c_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TrajNum (x:x:x)';
default{m,1}.entrystr = '1:1:1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RelRad';
default{m,1}.entrystr = '0.1';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Type';
default{m,1}.entrystr = 'AbsMax';
default{m,1}.options = {'AbsMax','RelMax','MatSteps'};

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Output';
default{m,1}.entrystr = 'kMat';
default{m,1}.options = {'Mat','KSA','GQKSA'};

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Plot';
default{m,1}.labelstr = 'Plot';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';
