%=========================================================
% 
%=========================================================

function [default] = PlotMontage_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Slices (a:b:c)';
default{m,1}.entrystr = '1:2:128';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Inset (T,B,L,R)';
default{m,1}.entrystr = '0,0,0,0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'nRows';
default{m,1}.entrystr = '8';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'imSize (v,h)';
default{m,1}.entrystr = '700,700';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'SliceLabel';
default{m,1}.entrystr = 'Yes';
default{m,1}.options = {'Yes','No'};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'FigNo';
default{m,1}.entrystr = 'Continue';

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'PlotImage';
default{m,1}.labelstr = 'Plot';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Plot';

