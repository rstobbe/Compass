%=========================================================
% 
%=========================================================

function [default] = FmriSlope_v1b_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MinSigVal';
default{m,1}.entrystr = '0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Significance';
default{m,1}.entrystr = '0.05';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Data';
default{m,1}.entrystr = 'Abs';
default{m,1}.options = {'Abs','Real'};