%=========================================================
% 
%=========================================================

function [default] = Plot_GEMTF_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Colour';
default{m,1}.entrystr = 'k';
default{m,1}.options = {'k','r','b','g','c','m'};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Exp Number';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Acq Number';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.labelstr = 'Plot_TF';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Plot';