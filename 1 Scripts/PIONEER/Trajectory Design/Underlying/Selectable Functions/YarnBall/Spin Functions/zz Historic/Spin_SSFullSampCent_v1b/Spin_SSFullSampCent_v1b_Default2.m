%=========================================================
% 
%=========================================================

function [default] = Spin_SSFullSampCent_v1b_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'CentDiam';
default{m,1}.entrystr = '5.0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SSCentSampFact';
default{m,1}.entrystr = '1.0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GblSampFact';
default{m,1}.entrystr = '1.0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RelTransLen';
default{m,1}.entrystr = '0.1';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SmoothBeta';
default{m,1}.entrystr = '25';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SmoothCenShift';
default{m,1}.entrystr = '0.02';