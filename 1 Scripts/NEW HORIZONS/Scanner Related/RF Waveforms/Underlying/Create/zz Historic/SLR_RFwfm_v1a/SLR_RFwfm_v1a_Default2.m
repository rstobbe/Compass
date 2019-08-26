%====================================================
%
%====================================================

function [default] = SLR_RFwfm_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SlvPts';
default{m,1}.entrystr = '128';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TimeBWprod';
default{m,1}.entrystr = '5.0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RippleIn';
default{m,1}.entrystr = '0.1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RippleOut';
default{m,1}.entrystr = '0.1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Flip';
default{m,1}.entrystr = '10';

m = m+1;
default{m,1}.entrytype = 'Choose';
default{m,1}.labelstr = 'RFtype';
default{m,1}.entrystr = 'Ex';
default{m,1}.options = {'Ex','Ref','Inv','MinPh','MaxPh'};


