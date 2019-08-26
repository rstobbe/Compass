%=========================================================
% 
%=========================================================

function [default] = Plot_Gridding2D_v1d_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Type';
default{m,1}.entrystr = 'abs';
default{m,1}.options = {'abs','phase','real','imag'};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MinVal';
default{m,1}.entrystr = '0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MaxVal';
default{m,1}.entrystr = '2';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Colour';
default{m,1}.entrystr = 'Colour';
default{m,1}.options = {'Colour','Grey'};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'FigNo';
default{m,1}.entrystr = 'Continue';

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Plot_GriddedSlices';
default{m,1}.labelstr = 'Plot';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Plot';