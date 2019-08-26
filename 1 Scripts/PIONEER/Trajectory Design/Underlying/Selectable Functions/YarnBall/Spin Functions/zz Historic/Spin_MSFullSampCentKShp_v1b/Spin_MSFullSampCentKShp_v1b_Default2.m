%=========================================================
% 
%=========================================================

function [default] = Spin_MSFullSampCentKShp_v1b_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'CentDiam';
default{m,1}.entrystr = '9.0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'CentScale';
default{m,1}.entrystr = '1.3';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'AddShpStartVal';
default{m,1}.entrystr = '2.0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'AddShpEndVal';
default{m,1}.entrystr = '1.0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'AddShpBeta';
default{m,1}.entrystr = '8.0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RelTransLen';
default{m,1}.entrystr = '0.04';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SmoothBeta';
default{m,1}.entrystr = '200';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SmoothCenShift';
default{m,1}.entrystr = '0.05';