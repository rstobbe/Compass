%=========================================================
% 
%=========================================================

function [default] = Plot_MEROI_PickSNR_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SNVR';
default{m,1}.entrystr = '0.234';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SNR';
default{m,1}.entrystr = '10';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Colour';
default{m,1}.entrystr = 'r-';

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.scrpttype = 'Plot';
default{m,1}.labelstr = 'Plot';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Run';
