%====================================================
%
%====================================================

function [default] = GradTestFileAnlz_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'Gradient_File';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc = 'SelectMatFile_v2';
default{m,1}.runfuncinput = {SCRPTPATHS.outrootloc};
default{m,1}.runfuncoutput = {SCRPTPATHS.outrootloc};