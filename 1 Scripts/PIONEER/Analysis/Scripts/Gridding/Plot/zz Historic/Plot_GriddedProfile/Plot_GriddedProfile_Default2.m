%=========================================================
% 
%=========================================================

function [default] = Plot_GriddedProfile_Default2(SCRPTPATHS)


m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Slice';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Orientation';
default{m,1}.entrystr = 'z';
default{m,1}.options = {'x','y','z'};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MaxVal';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.labelstr = 'Plot';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Plot';
default{m,1}.runfunc = 'Plot_GriddedSlices';