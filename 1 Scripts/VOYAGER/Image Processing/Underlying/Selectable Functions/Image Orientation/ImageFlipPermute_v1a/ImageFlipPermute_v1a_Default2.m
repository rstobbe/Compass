%=========================================================
% 
%=========================================================

function [default] = ImageFlipPermute_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Permute (123)';
default{m,1}.entrystr = '123';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Flip (000)';
default{m,1}.entrystr = '000';