%====================================================
%
%====================================================

function [default] = Write1GradFileV_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'RunExtFunc';
default{m,1}.labelstr = 'GradDefLoc';
default{m,1}.entrystr = '';
default{m,1}.buttonname = 'Select';
default{m,1}.runfunc = 'SelectDirectory_v2';
default{m,1}.runfuncinput = {SCRPTPATHS.outrootloc};
default{m,1}.runfuncoutput = {SCRPTPATHS.outrootloc};

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'sysgmax (mT/m)';
default{m,1}.entrystr = '59.7';
