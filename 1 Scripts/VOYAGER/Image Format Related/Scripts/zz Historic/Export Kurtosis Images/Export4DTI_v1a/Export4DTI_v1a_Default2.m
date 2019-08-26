%=========================================================
% 
%=========================================================

function [default] = Export4DTI_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'ExportImNum';
default{m,1}.entrystr = '1';

m = m+1;
default{m,1}.entrytype = 'RunScrptFunc';
default{m,1}.labelstr = 'Display Images';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Display';
default{m,1}.runfunc = 'Export4DTI_v1a';

