%=========================================================
% 
%=========================================================

function [default] = ImpType_OutInDualEcho_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'MaxRadEndDeriv';
default{m,1}.entrystr = '0.02';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'RadSlowFact';
default{m,1}.entrystr = '25';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'SpinSlowFact';
default{m,1}.entrystr = '5';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'PostDelay (us)';
default{m,1}.entrystr = '100';