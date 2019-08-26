%=========================================================
% 
%=========================================================

function [default] = TF_YarnBall_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Beta';
default{m,1}.entrystr = '4';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'EndDrop';
default{m,1}.entrystr = '20';