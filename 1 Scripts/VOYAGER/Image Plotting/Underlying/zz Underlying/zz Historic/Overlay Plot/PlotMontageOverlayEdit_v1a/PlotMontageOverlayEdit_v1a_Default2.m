%=========================================================
% 
%=========================================================

function [default] = PlotMontageOverlayEdit_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Intensity';
default{m,1}.entrystr = 'Flat50';
default{m,1}.options = {'Scaled','Flat25','Flat50','Flat100'};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'nColumns';
default{m,1}.entrystr = '8';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ImSize (v,h)';
default{m,1}.entrystr = '700,700';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'SliceLabel';
default{m,1}.entrystr = 'Yes';
default{m,1}.options = {'Yes','No'};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Figno';
default{m,1}.entrystr = '1000';