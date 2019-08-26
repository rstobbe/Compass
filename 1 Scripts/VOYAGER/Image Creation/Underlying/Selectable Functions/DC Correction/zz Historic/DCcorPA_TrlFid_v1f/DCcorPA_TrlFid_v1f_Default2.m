%====================================================
%
%====================================================

function [default] = DCcorPA_TrlFid_v1f_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TrlFid (%)';
default{m,1}.entrystr = '15';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SmthWin (pts)';
default{m,1}.entrystr = '100';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'Method';
default{m,1}.entrystr = 'Mean';
default{m,1}.options = {'Mean','Individual'};