%=========================================================
% 
%=========================================================

function [default] = SigDec_NaBiex_v1b_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'T2f';
default{m,1}.entrystr = '2.9';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'T2s';
default{m,1}.entrystr = '29';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'TE';
default{m,1}.entrystr = '0.194';
