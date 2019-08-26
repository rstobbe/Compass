%=========================================================
% 
%=========================================================

function [default] = TPI_SRIstandard_v1b_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'SRI_Data';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Load';
default{m,1}.runfunc = 'SelectMatFile_v2';
default{m,1}.runfuncinput = {''};
default{m,1}.runfuncoutput = {''};