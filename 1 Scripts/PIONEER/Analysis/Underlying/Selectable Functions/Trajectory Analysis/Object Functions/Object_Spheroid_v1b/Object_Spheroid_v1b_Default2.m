%=========================================================
% 
%=========================================================

function [default] = Object_Spheroid_v1b_Default2(SCRPTPATHS)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Diam (x:x:x mm)';
default{m,1}.entrystr = '3:1:10';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'Elip';
default{m,1}.entrystr = '2';

