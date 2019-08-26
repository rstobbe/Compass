%=========================================================
% 
%=========================================================

function [default] = Spin_MSFullSampCent_v1b_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'CentDiam';
default{m,1}.entrystr = '9.0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SSCentSampFact';
default{m,1}.entrystr = '1.15';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GblSampFact';
default{m,1}.entrystr = '0.5';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RelTransLen';
default{m,1}.entrystr = '0.02';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SmoothBeta';
default{m,1}.entrystr = '60';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SmoothCenShift';
default{m,1}.entrystr = '0.05';