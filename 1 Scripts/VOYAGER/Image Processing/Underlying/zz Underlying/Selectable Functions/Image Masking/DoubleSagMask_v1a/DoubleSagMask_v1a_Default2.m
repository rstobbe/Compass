%=========================================================
% 
%=========================================================

function [default] = DoubleSagMask_v1a_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'DispSup (mm)';
default{m,1}.entrystr = '0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'DispInf (mm)';
default{m,1}.entrystr = '0';