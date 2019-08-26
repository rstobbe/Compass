%=========================================================
% 
%=========================================================

function [default] = B0_BiExp_Manual_Default2(TestNum,level)

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'B0_TC1 (ms)';
default{m,1}.entrystr = '0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'B0_mag1 (uT)';
default{m,1}.entrystr = '0';

m = 1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'B0_TC2 (ms)';
default{m,1}.entrystr = '0';

m = m+1;
default{m,1}.entrytype = 'Input';
default{m,1}.labelstr = 'B0_mag2 (uT)';
default{m,1}.entrystr = '0';