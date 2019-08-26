%=========================================================
% 
%=========================================================

function [default] = Spin_ArbSampCent_v3a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'CentDiam';
default{m,1}.entrystr = '5.0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'CentSampFact';
default{m,1}.entrystr = '1.0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'GblSampFact';
default{m,1}.entrystr = '1.0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RelTransLen';
default{m,1}.entrystr = '0.1';
